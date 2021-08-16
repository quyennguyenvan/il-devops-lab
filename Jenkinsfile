pipeline {
  agent none

  environment {
    S3BUCKET = "s3-static-web-job-tf"
    region = "ap-northeast-1"
  }

  stages {
    stage("publish") {
      agent { node {label 'master'}}
       node('s3node'){
        withAWS(region:region,credentials:'aws-credential',useNode: true) {
          s3Upload(file:'index.html', bucket:S3BUCKET, path:'index.html')
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