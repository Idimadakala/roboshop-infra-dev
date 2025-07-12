output "mongodb_instance_id"{
    value = aws_instance.mongodb.id
}
output "redis_instance_id"{
    value = aws_instance.redis.id
}
output "mysql_instance_id"{
    value = aws_instance.mysql.id
}
output "rabbitmq_instance_id"{
    value = aws_instance.rabbitmq.id
}