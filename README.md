# Platform engineering test

This repository does not include the original problem specification, which is available locally

## Questions

Anything that requires clarification or further discussion will be listed here

### Is the front end provided by the Apache web servers or the load balancer ?  
  
In analysis of the server configuration, different investigatory techniques will be applied to web servers which provide access solely to public information and those which provide access to confidential information such as staff email.

### Which operating systems may be used for unprovisioned servers ?

It is stated that unprovisioned servers on which the solution should work will be clean installs, but not which operating system(s).

### How much time do changes take currently ?

An improvement in delivery time should be established
 
### Can the load balancer affect the operation of the web servers ?

A simple load balancing approach should not; a more sophisticated approach may involve changes to the requests and responses.

## Assumptions

Any assumptions that have been made will be listed here so that they can be tested where possible

**The username ubuntu does not mean that the target operating system is ubuntu.**  Check the OS on the server.

**The load balancer does not affect the operation of the web servers.** I've requested further information about this.

**Tweaks to the Apache configuration were conducted within the Apache configuration files.** Investigation may extend to other areas of the operating system.

**The web developers mentioned in the user story are internal staff in the web team mentioned in the background.** Solutions available to permanent staff may not be available to contract, freelance or other web developers.

**The platform engineer has a working local environment.** Git installed, an active internet connection and the PEM file that was supplied for authentication with the target.

## Approach and rationale

The strategy for providing a solution and the reasoning behind the choices made

Determining the condition of the server will assist in selecting appropriate tools and techniques

Information gathering will include port scanning, OS detection, ownership and any other information of public record

Communication with and between the stakeholders would usually form part of the investigation

### Stakeholders

* University of Leodis
* Platform engineer
* Web development team
* System administration team

### Prepare local environment

1 Clone this repository with Git, avoiding inclusion of sensitive information

    [you@local ~]$ mkdir git
    [you@local ~]$ cd git
    [you@local git]$ git clone https://github.com/infinity-technical/platform-engineering.git

2 Store credentials away from the local Git repository

    [you@local ~]$ mv ~/Downloads/Techtest-XXX-XXX.pem ~/.ssh
    [you@local ~]$ chmod 400 ~/.ssh/Techtest-XXX-XXX.pem

## Investigation

Information about the problem that enhances the original statement

### Port scan target machine

A polite port scan shows three ports listening

* 22
* 80
* 443

[Full port scan log](./port-scan.md)

### Browse the target

The web server delivers HTML in response to an HTTP GET request

### Connect to target using SSH 

Using supplied credentials

### Establish the operating system on the target

### Verify listening ports

The standards ports for SSH, HTTP & HTTPS were found by the port scan

Verify whether they are connected as expected

## Documentation

Information about delivering the solution

## Resources

Code, examples and other non-documentary information