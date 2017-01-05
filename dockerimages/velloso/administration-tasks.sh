# Switch to OpenShift Project
echo ">>> Step 1: Switching to Project/Namespace OpenShift"
oc project openshift
# Delete previous image 
echo ">>> Step 2: Deleting previous existing ImageStream: tomcat7alpine and oracle-xe-11g"
oc delete imagestream/tomcat7alpine --namespace openshift
oc delete imagestream/oracle-xe-11g --namespace openshift
# Import the image
echo ">>> Importing Image: docker.io/fabiovelloso/tomcat7alpine:latest"
oc import-image --confirm=true --insecure=true docker.io/fabiovelloso/tomcat7alpine:latest --namespace openshift
echo ">>> Importing Image: docker.io/wnameless/oracle-xe-11g:latest"
oc import-image --confirm=true --insecure=true docker.io/wnameless/oracle-xe-11g:latest --namespace openshift
