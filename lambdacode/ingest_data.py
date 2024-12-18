import json
import boto3
import psycopg2
import time
from datetime import datetime


s3_client = boto3.client('s3')


textract_client = boto3.client('textract')


rds_host = "localhost"
db_name = "2mo"
db_user = "admin"
db_password = "admin123"

def lambda_handler(event, context):

    bucket_name = event['detail']['bucket']['name']
    file_key = event['detail']['object']['key']
    

  
    response = textract_client.start_document_text_detection(
        DocumentLocation={'S3Object': {'Bucket': bucket_name, 'Name': file_key}}
    )
    
   
    job_id = response['JobId']
    print(f"Textract starts job with ID: {job_id}")

    response = textract_client.start_document_text_detection(
        DocumentLocation={'S3Object': {'Bucket': bucket_name, 'Name': file_key}}
    )
    
    
    # run job
    while True:
        result = textract_client.get_document_text_detection(JobId=job_id)
        if result['JobStatus'] == 'SUCCEEDED':
            break
        time.sleep(5)
    
    # Extract text
    text = "\n".join([block['Text'] for block in result['Blocks'] if block['BlockType'] == 'LINE'])

    # Print the extracted text
    print(text)

    return {
        'statusCode': 200,
        'body': json.dumps('Text extraction complete.')
    }