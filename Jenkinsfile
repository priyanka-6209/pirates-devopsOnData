  pipeline {
    agent any
     tools{
        maven 'maven'
          }
    stages {
        
        stage('Build') {
              steps {
                  sh "mvn -B -DskipTests clean package"
                  archiveArtifacts artifacts: 'target\pirates-0.0.1-SNAPSHOT-jar-with-dependencies.jar'
            }
        }    
        
       stage('Perform Sonarqube analysis')
        {
                     steps   {

                                sh "mvn sonar:sonar -Dsonar.host.url=http://54.190.168.185:30002"
                        }
        }
        
    
  
    stage('Build Docker image'){
                       
            steps {
                script {
                    app = docker.build("priyanka6209/pirates")
                    app.inside {
                        sh 'echo $(curl localhost:80)'
                    }
                }
            }  
    }
      
                         
        stage('Push docker image'){
           
            steps{
                script {
                    docker.withRegistry('https://registry.hub.docker.com','pirates_hub_login'){
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
      
      
      stage('Run Dockerbench Scan'){  
      steps {
                script {
                    
             sh     'docker run --net host --pid host --cap-add audit_control \
                   -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
                    -v /var/lib:/var/lib \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    -v /usr/lib/systemd:/usr/lib/systemd \
                    -v /etc:/etc --label docker_bench_security \
                    priyanka6209/pirates | tee DockerBenchOutput.txt'
                    
                }
        
                archiveArtifacts artifacts: 'DockerBenchOutput.txt'
            }  
      
        }
      
       stage('Deploy kubernetes'){
          
          steps {
           kubernetesDeploy(
                kubeconfigId: 'kubeconfig',
                configs: 'application.yaml',
                enableConfigSubstitution: true)
                echo 'App url: http://54.190.168.185:30030'
          }
                     
        }    
      
       
      
        
    }
}
