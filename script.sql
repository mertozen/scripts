import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('YourTableName')

def lambda_handler(event, context):
    items = []

    for record in event['Records']:
        # Assuming each record body contains JSON string
        item = parse_record(record)
        items.append(item)

    with table.batch_writer(overwrite_by_pkeys=['id']) as batch:
        for item in items:
            batch.put_item(Item=item)

    return {"statusCode": 200, "body": f"{len(items)} items inserted."}

def parse_record(record):
    # Example: parse JSON from SQS or Kinesis
    import json
    return json.loads(record['body'])
