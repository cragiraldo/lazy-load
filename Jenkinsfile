pipeline{
    parameters {
        string(name: 'DB_HOST', defaultValue: 'ds029837.mlab.com', description: 'host of the application')
        string(name: 'PORT', defaultValue:'29837', description: 'Port use to conect DB')
        string(name: 'database', defaultValue: 'lazy_load_dev')

    }
    environment{
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any

    tools{
        gradle 'Gradle-4.5.1'
        terraform 'terraform0.15.4'
    }

    stages{
        stage("create ami"){
            steps{
                echo "====++++executing create ami++++===="
                script{
                    dir("packer"){
                        sh 'packer init'
                        sh 'packer build aws-lazyapp.pkr.hcl'
                    }
                }
            }
        }
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
