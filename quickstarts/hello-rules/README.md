## Red Hat Decision Manager Kie Server Quickstart

This quickstart is intend to be used with the [RHDM Kie Server](https://github.com/jboss-container-images/rhdm-7-openshift-image/tree/master/kieserver) image.

## How to use it?

[rhdm72-prod-immutable-kieserver](https://github.com/jboss-container-images/rhdm-7-openshift-image/blob/master/templates/rhdm72-prod-immutable-kieserver.yaml)

To deploy it on your OpenShift instance, just execute the following commands:


```bash
$ oc login https://<your_openshift_address>:<port>
Authentication required for https://ocp-master.cloud.com:8443 (openshift)
Username: developer
Password: 
Login successful.

```

Create a new project, i.e.:

```bash
$ oc new-project rhdm
Now using project "rhdm" on server "https://ocp-master.severinocloud.com:8443".
```

Make sure that you have the RHDM template installed in your OpenShift Instance:
```bash
$ oc get template rhdm72-prod-immutable-kieserver -n openshift
Error from server (NotFound): templates "rhdm72-prod-immutable-kieserver" not found
```
If you don't have it yet, just install it:

```bash
oc create -f https://raw.githubusercontent.com/jboss-container-images/rhdm-7-openshift-image/master/templates/rhdm72-prod-immutable-kieserver.yaml -n openshift
template "rhdm72-prod-immutable-kieserver" created
```

For this template, we also need to install the secrets, which contain the certificates to configure https:
```bash
$ oc create -f https://raw.githubusercontent.com/jboss-container-images/rhdm-7-openshift-image/master/example-app-secret-template.yaml
$ oc new-app example-app-secret -p SECRET_NAME=decisioncentral-app-secret
--> Deploying template "rhdm1/example-app-secret" to project rhdm

     example-app-secret
     ---------
     Examples that can be installed into your project to allow you to test the Red Hat Decision Central templates. You should replace the contents with data that is more appropriate for your deployment.

     * With parameters:
        * Secret Name=decisioncentral-app-secret

--> Creating resources ...
    secret "decisioncentral-app-secret" created
--> Success
    Run 'oc status' to view your app.
```

```bash
$ oc new-app rhdm72-prod-immutable-kieserver \
-p KIE_SERVER_HTTPS_SECRET=decisioncentral-app-secret \
-p KIE_SERVER_CONTAINER_DEPLOYMENT=hellorules=org.openshift.quickstarts:rhdm-kieserver-hellorules:1.4.0-SNAPSHOT \
-p SOURCE_REPOSITORY_URL=https://github.com/jboss-container-images/rhdm-7-openshift-image.git \
-p SOURCE_REPOSITORY_REF=master \
-p CONTEXT_DIR=quickstarts/hello-rules/hellorules
  --> Deploying template "openshift/rhdm72-prod-immutable-kieserver" to project rhdm1

     Red Hat Decision Manager 7.2 immutable production environment
     ---------
     Application template for an immultable KIE server in a production environment, for Red Hat Decision Manager 7.2

     A new immutable Red Hat Decision Manager KIE server have been created in your project.
     The username/password for accessing the KIE server is
     
         Username: executionUser
         Password: QTSdSM4!
     
     Please be sure to create the secret named "decisioncentral-app-secret" containing the keystore.jks files used for serving secure content.

     * With parameters:
        * Application Name=myapp
        * KIE Admin User=adminUser
        * KIE Admin Password=ujcLVk2! # generated
        * KIE Server User=executionUser
        * KIE Server Password=QTSdSM4! # generated
        * ImageStream Namespace=openshift
        * KIE Server ImageStream Name=rhdm72-kieserver-openshift
        * ImageStream Tag=1.0
        * KIE Server Controller User=controllerUser
        * KIE Server Controller Password=
        * KIE Server Controller Token=
        * KIE Server Controller Service=
        * KIE Server Controller host=
        * KIE Server Controller port=
        * Drools Server Filter Classes=true
        * KIE MBeans=enabled
        * KIE Server Custom http Route Hostname=
        * KIE Server Custom https Route Hostname=
        * Use the secure route name to set KIE Server location.=false
        * KIE Server Keystore Secret Name=decisioncentral-app-secret
        * KIE Server Keystore Filename=keystore.jks
        * KIE Server Certificate Name=jboss
        * KIE Server Keystore Password=mykeystorepass
        * KIE Server Bypass Auth User=false
        * KIE Server Container Deployment=hellorules=org.openshift.quickstarts:rhdm-kieserver-hellorules:1.4.0-SNAPSHOT
        * Git Repository URL=https://github.com/jboss-container-images/rhdm-7-openshift-image.git
        * Git Reference=master
        * Context Directory=quickstarts/hello-rules/hellorules
        * Github Webhook Secret=Uhamio24 # generated
        * Generic Webhook Secret=GqA8F1TX # generated
        * Maven mirror URL=
        * Maven repository ID=
        * Maven repository URL=
        * Maven repository username=
        * Maven repository password=
        * Name of the Maven service hosted by Decision Central=
        * Username for the Maven service hosted by Decision Central=
        * Password for the Maven service hosted by Decision Central=
        * List of directories from which archives will be copied into the deployment folder=
        * KIE Server Container Memory Limit=1Gi
        * Disable KIE Server Management=true
        * KIE Server Startup Strategy=LocalContainersStartupStrategy
        * RH-SSO URL=
        * RH-SSO Realm name=
        * KIE Server RH-SSO Client name=
        * KIE Server RH-SSO Client Secret=
        * RH-SSO Realm Admin Username=
        * RH-SSO Realm Admin Password=
        * RH-SSO Disable SSL Certificate Validation=false
        * RH-SSO Principal Attribute=preferred_username
        ...

W1009 15:35:32.176038   20956 newapp.go:1203] Unable to check for circular build input: Unable to check for circular build input/outputs: imagestreams.image.openshift.io "rhdm72-kieserver-openshift" not found
--> Creating resources ...
    serviceaccount "myapp-kieserver" created
    rolebinding "myapp-kieserver-view" created
    service "myapp-kieserver" created
    service "myapp-kieserver-ping" created
    route "myapp-kieserver" created
    route "secure-myapp-kieserver" created
    imagestream "myapp-kieserver" created
    buildconfig "myapp-kieserver" created
    deploymentconfig "myapp-kieserver" created
--> Success
    Access your application via route 'myapp-kieserver-rhdm1.severinocloud.com' 
    Access your application via route 'secure-myapp-kieserver-rhdm1.severinocloud.com' 
    Build scheduled, use 'oc logs -f bc/myapp-kieserver' to track its progress.
    Run 'oc status' to view your app.

```

Now you can deploy the [hellorules-client](hellorules-client) in the same or another project and test RHDM Kie Server container.

To deploy the hello rules client you can use the **eap71-basic-s2i** (It is available in the OpenShift Catalog) template and specify the above quickstart to be deployed.
To do so, execute the following commands:

```bash
$ oc new-app eap71-basic-s2i \
-p SOURCE_REPOSITORY_URL=https://github.com/jboss-container-images/rhdm-7-openshift-image.git \
-p SOURCE_REPOSITORY_REF=master \ 
-p CONTEXT_DIR=quickstarts/hello-rules
```

As result you should see something like this:
```bash
--> Deploying template "openshift/eap71-basic-s2i" to project rhdm

     JBoss EAP 7.1 (no https)
     ---------
     An example EAP 7 application. For more information about using this template, see https://github.com/jboss-openshift/application-templates.

     A new EAP 7 based application has been created in your project.

     * With parameters:
        * Application Name=eap-app
        * Custom http Route Hostname=
        * Git Repository URL=https://github.com/jboss-container-images/rhdm-7-openshift-image.git
        * Git Reference=master
        * Context Directory=quickstarts/hello-rules
        * Queues=
        * Topics=
        * A-MQ cluster password=wMafLKF6 # generated
        * Github Webhook Secret=BKqfureQ # generated
        * Generic Webhook Secret=V8QsIkAW # generated
        * ImageStream Namespace=openshift
        * JGroups Cluster Password=kqnf2NGT # generated
        * Deploy Exploded Archives=false
        * Maven mirror URL=
        * Maven Additional Arguments=-Dcom.redhat.xpaas.repo.jbossorg
        * ARTIFACT_DIR=
        * MEMORY_LIMIT=1Gi

--> Creating resources ...
    service "eap-app" created
    service "eap-app-ping" created
    route "eap-app" created
    imagestream "eap-app" created
    buildconfig "eap-app" created
    deploymentconfig "eap-app" created
--> Success
    Access your application via route 'eap-app-rhdm1.severinocloud.com' 
    Build scheduled, use 'oc logs -f bc/eap-app' to track its progress.
    Run 'oc status' to view your app.
```

After the application is built, access the hello rules client app through the route created:
```bash

$ oc get routes eap-app
NAME      HOST/PORT                               PATH      SERVICES   PORT      TERMINATION   WILDCARD
eap-app   eap-app-rhdm.<your_openshift_suffix>              eap-app    <all>                   None
```

Note that this route should be resolvable.

And example of request would be something like this:

```bash
http://eap-app-rhdm-kieserver.<your_openshift_suffix>/hellorules?command=runRemoteRest&protocol=http&host=myapp-kieserver-rhdm-kieserver.<your_openshift_suffix>&port=80&username=executionUser&password=<the_generated_kie_password>
```

The password was generated during the app creation in the previous steps, look for **KIE Server Password**.

#### Found an issue?
Feel free to report it [here](https://github.com/jboss-container-images/rhdm-7-openshift-image/issues/new).
