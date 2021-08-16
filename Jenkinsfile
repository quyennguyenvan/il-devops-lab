pipeline {

  agent none

  environment {
    S3BUCKET = "s3-static-web-job-tf"
    region = "ap-northeast-1"
  }

  stages {
    stage("publish") {
      agent { node {label 'master'}}
      steps {
        pwd(); //Log current directory
        withAWS(region:region,credentials:'aws-credential') {
            def identity=awsIdentity();//Log AWS credentials
            s3Upload(bucket:S3BUCKET, workingDir:'./', includePathPattern:'**/*');
        }
      }
    }
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}