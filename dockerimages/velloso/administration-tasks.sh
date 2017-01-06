# Switch to OpenShift Project
echo ">>> Step 1: Switching to Project/Namespace OpenShift"
oc project openshift
# Delete previous image 
echo ">>> Step 2: Deleting previous existing ImageStream: tomcat7alpineos and oracle-xe-11g"
oc delete imagestream/tomcat7alpineos --namespace openshift
oc delete imagestream/oracle-xe-11g --namespace openshift
oc delete template/tomcat-velloso --namespace openshift
# Creating template into Project/Namespace Openshift
oc create -f template/tomcat-velloso.yaml --namespace openshift
# Import the image
echo ">>> Importing Image: docker.io/fabiovelloso/tomcat7alpineos:latest"
oc import-image --confirm=true --insecure=true docker.io/fabiovelloso/tomcat7alpineos:latest --namespace openshift
echo ">>> Importing Image: docker.io/wnameless/oracle-xe-11g:latest"
oc import-image --confirm=true --insecure=true docker.io/wnameless/oracle-xe-11g:latest --namespace openshift
# Let user: demo into scc/anyuid
echo ">>> Adding user demo into scc/anyuid"
oadm policy add-scc-to-user anyuid demo
# IMPORTANT: Add as many serviceaccounts into scc/privileged, based on project's name
# Example: Let's suppose you wanted to create a project named "testbanco"
#          oadm policy add-scc-to-user privileged system:serviceaccount:testbanco:velloso
