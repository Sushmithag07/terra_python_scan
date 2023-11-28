""" This is a testing lambda 2 module """
import json

# pylint: disable=unused-argument
def lambda_handler(event, context):
    """Sample pure Lambda 2 function
    Parameters
    ----------
    event: dict
    context: object, required
        Lambda Context runtime methods and attributes
    Returns
    ------
    Output Format: dict
    """
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "A message from Lambda 2",
            }
        ),
    }
