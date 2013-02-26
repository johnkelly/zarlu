---
layout: post
title: How Does Zarlu Secure My Data?
---
#How does Zarlu secure my data?# {: .center}
***
In the past few years there has been a movement to move data from local computers into the cloud. Cloud Storage provides many benefits: it can be accessed from multiple devices, your data can stay synced between machines, and cloud providers are a backup for your data. One downside to cloud applications is that the user is giving up control of their data and trusting a 3rd party vendor to keep their data safe. As a cloud web application, I designed Zarlu to be worthy of your trust.

##SSL
Look in the url of your web browser.  Do you the prefix https:// instead of http://? Zarlu uses SSL on every page of our application to ensure that your activity on Zarlu is encrypted. This is the same encryption used by banks for their web pages. Zarlu uses a 256 bit encryption algorithm to encrypt your data when we send it to you.  Many browsers represent this connection with a padlock icon to notify you that your connection is secure. Many websites do not encrypt even their log in form, which means that if you log on to their software from a public place (Starbucks, airport, etc) a hacker can steal your username and password. By using SSL for our forms, we protect you from this.

##Payment Information
When you decide to use one our wonderful paid plans, Zarlu asks you for your credit card so that we can charge you for the plan you selected. When you fill out the credit card form and hit submit, your credit card information goes directly to our payment provider <a href="http://www.stripe.com" target="_blank">Stripe</a>.  Stripe handles all your payment information and then lets us know that your account has been paid for. We then store your last 4 digits of your credit card only so that we can show you which credit card of yours Stipe has on file in case you wish to change cards for a future payment. Your credit card number, security code, expiration month, and expiration year never even touch our servers. We send this information directly to Stripe using the https protocol that encrypts your information when we send it to Stripe. Https is the same protocol used by banks.  We don't even log your credit card info.  Zarlu does this because Stripe handles payment security at the most stringent level possible.  They are certified as a PCI Service Provider Level 1 the highest level possible and are used by thousands of applications for their commitment to security. By using Stripe, Zarlu is also PCI compliant.

##Password
Have you heard of all the recent high profile security breaches where users passwords have been stolen? Many websites store your password simply as plain text, which means in their data if your password is 123456 then their data says your password is 123456. Software can never be perfect, so to protect this we encrypt your password. So if there is ever a security breach on Zarlu, when the attacker looks at your password they will see something like fdlksjfferr98weurwiewf instead of 123456. You many have noticed that our login forms say pass phrase instead of password.  We want to encourage you to use a phrase or even a sentence instead of a single word.  It is much harder for someone to guess "My son's name is John, and I love going hiking with him!" then "password1". Keep that trick in mind for other passwords as well!

##Software
Zarlu uses several programming languages and frameworks to give you the best scheduling experience. I check for any updates, bug fixes, or patches on a daily basis to ensure that our software is secure.

##Data Backups
Depending on your plan level, we either backup your data on a weekly or daily basis. If something goes wrong on our end (server failure, etc), we have a copy.

I hope this page has given you a better understanding of how much we value the security of your information here at Zarlu. If you have any additional concerns feel free to contact us by clicking on the support link. If you have detected any security vulnerability in the Zarlu software, please click on support and let us know! Good deeds are rewarded!
