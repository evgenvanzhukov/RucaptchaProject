# Rucaptcha

Simple studiing project for recognize digits on photo using ReCaptcha service https://rucaptcha.com/api-rucaptcha.

It contains only buttons: for pick an image, for send to recognize, and for check the answer.

Before send request image cropped at selected area. 

I am going to use it in my pet project UtilityMeters for recognize value from photo.

#### What challenges i has when worked  on this project:
* Recaptcha api works with multipart form data type. I'm used to  deal with json data, and forgot when last time used multipart forms.  Fortunately postman can generate code snippets with different languages include swift and saved my time.

* cropping part of big image had me to research frames and relations between subviews for calculating. And to learn how to add scrollable zoomable UIImage at scrollview. Thanks for author  of this tutorial https://www.youtube.com/watch?v=YpVZgQW1TvQ 

![image](https://user-images.githubusercontent.com/29074231/205481439-676edbd7-7a49-4fa8-bee1-12c6624d6b8e.png)
