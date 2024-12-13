import json
import boto3
import psycopg2
import re
from datetime import datetime


s3_client = boto3.client('s3')
textract_client = boto3.client('textract')


rds_host = "localhost"
db_name = "2mo"
db_user = "admin"
db_password = "admin123"


def lambda_handler(event, context):
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    

    print(f"Downloading {file_key} from bucket {bucket_name}")



    s3_client.download_file(bucket_name, file_key, '/uploads/{}'.format(file_key))
    

    print(f"Processing file {file_key}")
    response = textract_client.detect_document_text(
        Document={'S3Object': {'Bucket': bucket_name, 'Name': file_key}}
    )
    

    extracted_text = ''
    for item in response['Blocks']:
        if item['BlockType'] == 'LINE':

            extracted_text += item['Text'] + '\n'
    
    
    shopping_details = parse_shopping_details(extracted_text)
    for detail in shopping_details:


        insert_shopping_details_to_db(detail['goods_name'], detail['amount'], detail['price'], detail['insert_time'], detail['user'])
    
    return {
        'statusCode': 200,
        'body': json.dumps('succes')
    }






def parse_shopping_details(extracted_text):
    shopping_details = []
    lines = extracted_text.split('\n')
    
    for line in lines:
        match = re.match(r"([a-zA-Z\s]+)\s+(\d+)\s+(\d+\.\d{2})", line.strip())
        if match:
            goods_name = match.group(1).strip()
            amount = int(match.group(2))

            price = float(match.group(3))
            insert_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            #maybe rename the S3 object to original_filname_usename.jpg or figure out how to send the upload user name to lambda
            user = "local_user"
            
            shopping_details.append({
                'goods_name': goods_name,
                'amount': amount,
                'price': price,
                'insert_time': insert_time,
                'user': user
            })
    
    return shopping_details

def insert_shopping_details_to_db(goods_name, amount, price, insert_time, user):

    print(f"Connecting to database ")
    connection = psycopg2.connect(
        host=rds_host,
        dbname=db_name,
        user=db_user,
        password=db_password
    )
    cursor = connection.cursor()
    

    insert_query = """
    INSERT INTO raw_shopping_details (goods_name, amount, price, insert_time, user)
    VALUES (%s, %s, %s, %s, %s);
    """
    cursor.execute(insert_query, (goods_name, amount, price, insert_time, user))
    
    connection.commit()
    cursor.close()
    connection.close()
    print(f"Inserted {goods_name}")