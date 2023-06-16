# Setting up S3 Bucket Notifications with Terraform

S3 bucket notifications are a useful feature of Amazon’s Simple Storage Service (S3) that allow us to receive notifications when certain events occur in our S3 bucket. These notifications can be sent to a variety of targets, such as an AWS Lambda function, an Amazon SNS topic, or an SQS queue.

## Configuring S3 Bucket Notifications to an SNS Queue

The following Terraform code will create an SNS topic and configure S3 bucket notifications to send messages to the email when an object is created in the S3 bucket.

### First, Create  an S3 bucket:
#### s3Bucket.tf
```
resource "aws_s3_bucket" "anitha-bucket"{
  bucket = "anitha8368"

  tags = {
    Name = "anitha"
  }
}
```
### Next, create an SNS topic. Note that the SNS topic must have a policy that allows the S3 bucket to send messages to the target.create the S3 bucket notification. The filter_suffix attribute can be used to filter the notifications to only those objects that have a specific suffix. In this example, we will only receive notifications for objects that have a .png suffix.

#### SNStopic.tf
```
resource "aws_sns_topic" "topic" {
  name = var.sns_name
  

policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "AWS": "*" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:${var.sns_name}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.anitha-bucket.arn}"}
        }
    }]
}
POLICY
}
resource "aws_s3_bucket_notification" "bucket_notification"{
    bucket = aws_s3_bucket.anitha-bucket.id
  topic {
    topic_arn = aws_sns_topic.topic.arn
   id = "notify created"
    events = [ "s3:ObjectCreated:*" ]
   filter_suffix = ".png"
  }  

}
```
### Subscribe to the SNS topic via email
#### Subscription.tf
```
resource "aws_sns_topic_subscription" "email-target"{

    topic_arn = aws_sns_topic.topic.arn
    protocol = "email"
    endpoint = "kudupudi.anitha@gmail.com"
}  
```
### Conclusion:
Amazon S3 bucket notifications are a powerful and versatile feature that can be used to receive notifications when certain events occur in an S3 bucket. By configuring S3 bucket notifications, we can automate processes and trigger actions in response to events such as when an object is created, deleted, or restored in the S3 bucket.In the above example i get an email whenever put event occurs in s3 bucket.



  
