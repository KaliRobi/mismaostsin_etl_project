import os
import psycopg2
import boto3
import logging
import time

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        
        
        bucket_name = event['detail']['bucket']['name']
        file_key = event['detail']['object']['key']
        

        logger.info(f"File and bucket name extracted: {bucket_name}, {file_key}")

        
        textract_client = boto3.client('textract', region_name='eu-central-1')
        logger.info("Textract client initialized")

        # Start  job
        response = textract_client.start_document_text_detection(
            DocumentLocation={'S3Object': {'Bucket': bucket_name, 'Name': file_key}}
        )
        job_id = response['JobId']
        logger.info(f"Textract starts job with ID: {job_id}")

        # Poll for job completion
        max_retries = 5
        retry_interval = 10  # seconds

        for _ in range(max_retries):
            result = textract_client.get_document_text_detection(JobId=job_id)
            if result['JobStatus'] == 'SUCCEEDED':
                logger.info("Textract job succeeded")
                break
            elif result['JobStatus'] in ['FAILED', 'PARTIAL_SUCCESS']:
                raise Exception(f"Textract job failed with status: {result['JobStatus']}")
            time.sleep(retry_interval)
        else:
            raise Exception("Textract job did not complete in the expected time")

        # get results
        if 'Blocks' not in result:
            raise Exception("No text blocks found in the Textract response")
        text = "\n".join([block['Text'] for block in result['Blocks'] if block['BlockType'] == 'LINE'])
        
        logger.info(f"Extracted text: {text}")

        return {
            'statusCode': 200,
            'body': text
        }
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': str(e)
        }
