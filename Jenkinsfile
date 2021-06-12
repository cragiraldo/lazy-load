pipeline{
    parameters {
        string(name: 'DB_HOST', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')

    }
    environment{
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any

    tools{
        gradle 'Gradle-4.5.1'
        terraform 'terraform'
    }

    stages{
        stage("build"){
            steps{
                echo "========executing build========"
                script{
                    dir("lazy-load-backend"){
                        sh './gradlew build'
                    }
                }
            }
        }
        stage("test"){
            steps{
                echo "========executing test========"
                script{
                    dir("lazy-load-backend"){
                        sh './gradlew test'
                    }
                }
            }

        }
    }
    post{
        always{
            echo "====++++always++++===="
            junit 'lazy-load-backend/build/test-results/test/*.xml'
            
        }
    }
}
