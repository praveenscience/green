# UW's Green Certification programs

Green Certification Programs at the University of Washington are recognition programs intended to reduce the environmental impact of various spaces across campus by educating students, faculty, and staff about sustainable practices. The programs provide an evaluation framework with resources to implement the practices within their spaces, in alignment with strategies laid out in the UW Climate Action Plan.

## Setup

### Softwares required

Make sure that these softwares are installed on your machine

1. Node.js
2. Mongo DB
3. Ruby (For deploying)

### Setting up the repo

1. Once you get all the softwares installed on your machine you can clone the repo to your local machine. Use the following command to clone the repo ```git clone https://github.com/websiddu/green.git```
2. Then ```cd green```
3. Install all the dependencies using ```npm i && bower install```
4. After the success message you should be able to run the repo using the command ```grunt serve```

### Deploying code to the server

Deploying code the server is very simple

1. On your project folder run `bundle install` if it says bundle command not found then run `gem install bundler`
2. Then you can just do `cap deploy production` to deploy the code to production server

## Contributing
Always make sure that you create a feature branch. Don't ever push to master. You should always create a merge request to the master branch instead of pushing coded directly to master. To do so, follow the below steps

1. `git pull` on your project folder
2. `git checkout master` sets master as current branch
3. `git pull --rebase origin master` pulls the latest code on the master
4. `git checkout -b new_feature` makes a new branch
5. Do your changes
6. `git add .`
7. `git commit -m "This is a new feature"`
8. `git push origin new_feature`
9. Goto https://github.com/websiddu/green and create a merge request

## Issues
Open a new issue whenever you find a bug in the code under the issues page https://github.com/websiddu/green/issues

## Contact
If you have any questions drop an email to siddu@uw.edu


