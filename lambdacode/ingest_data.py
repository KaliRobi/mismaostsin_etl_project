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
    

    s3_object = s3_client.get_object(Bucket=bucket_name, Key=file_key)
    image_data = s3_object['Body'].read()


    response = textract_client.start_document_text_detection(
        DocumentLocation={'S3Object': {'Bucket': bucket_name, 'Name': file_key}}
    )
    
   
    job_id = response['JobId']
    print(f"Started Textract job with ID: {job_id}")

