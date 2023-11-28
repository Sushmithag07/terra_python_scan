""" This is a testing lambda 1 module """
import json

# pylint: disable=unused-argument
def lambda_handler(event, context):
    """Sample pure Lambda function

    Parameters
    ----------
    event: dict, required
        Input Format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    Output Format: dict
    """

    return {"body": json.dumps({"msg": "hello from Lambda 1"}), "statusCode": 200}
