pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "482976502347.dkr.ecr.ap-northeast-1.amazonaws.com/il_py_app"
    credentialsId = "aws-jenkins-intergration-access-key"
  }

  stages {
    stage("build_and_deployment") {
      agent { node {label 'app-python'}}
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
        sh "docker image ls | grep ${DOCKER_IMAGE}"
        withDockerRegistry([url: "https://"+DOCKER_IMAGE,credentialsId:credentialsId]) {
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
            sh "docker push ${DOCKER_IMAGE}:latest"
        }

        //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
        sh "docker image rm ${DOCKER_IMAGE}:latest"
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