# postalhub_admin_cms

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


User Hierarchy truth table
(ADMIN Previlage)  = 1
Email : admin@postalhub.web.app
Password : admin@672027

(Operator Previlage) = 2
1. UTP
Email : utp@postalhub.web.app
Password : utp@6720

2. UM
Email : um@postalhub.web.app
Password : um@5626


=================================================

Parcel Status truth table
1. 
ARRIVED    = 1
DELIVERY   = 0
DELIVERED  = 0

2. 
ARRIVED    = 1
DELIVERY   = 1
DELIVERED  = 0

3. 
ARRIVED    = 1
DELIVERY   = 1
DELIVERED  = 1

4. (Not in use)
ARRIVED    = 1
DELIVERY   = 0
DELIVERED  = 1


=================================================

Parcel Category truth table
1. Normal
2. Self-Collect
3. COD



=================================================

firebase deploy --only hosting:postalhub-cms
firebase deploy --only hosting:postalhub-cms-beta
