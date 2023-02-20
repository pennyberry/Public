Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -Force
Install-AdcsWebEnrollment -force

#rdp into the cert authority 
#create a duplicate template of computers
#set acl of domain computers to autoenroll
#set subject name to be DNS name
#create the template

#right click certificate templates
#new->certificate template to issue->issue the cert