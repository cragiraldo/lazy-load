pipeline{
    agent any

    tools{
        gradle 'Gradle-4.5.1'
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
