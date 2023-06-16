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

  