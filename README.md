# Structure

The approach I took on the structure of this infrastructure is to follow the multi-account structure, this is why terragrunt has been introduced to simplify deployment (this is not strictly required).

Elastic Beanstalk does have a harder job with this setup due to it being designed to all run in a single account however a way around this, is by using a single beanstalk environment with a single application in each AWS account.

# Deprecation Issue

Due to a deprecation in EB, new environments should be created with IDSM 1 disabled and storage should use GP3.

# References

https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/benefits-of-using-multiple-aws-accounts.html
