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
        sh "ls -ll"
        pwd();
        withAWS(region:region,credentials:'aws-credential') {
            def identity=awsIdentity();//Log AWS credentials
            s3Upload(entries:S3BUCKET, workingDir:'.', includePathPattern:'**/*');
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