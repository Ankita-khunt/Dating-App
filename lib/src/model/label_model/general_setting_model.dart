import 'package:dating_app/imports.dart';

class GeneralSetting extends Serializable {
  String? email;
  String? phone;
  String? currency;
  String? currencyCode;
  String? serviceCharge;
  String? facebookLink;
  String? instagramLink;
  String? twitterLink;
  String? countrycode;
  String? commisionPercentage;
  String? driverCommisionPercentage;
  String? driverDeliveryRate;
  String? taxPercentage;
  String? rewardPoints;
  String? delaySeconds;
  String? s3BucketName;
  String? s3AccessKey;
  String? s3SecretAccessKey;
  String? s3Url;
  String? s3Region;
  String? imgRestaurant;
  String? imgGroccery;

  GeneralSetting(
      {this.email,
      this.phone,
      this.currency,
      this.currencyCode,
      this.serviceCharge,
      this.facebookLink,
      this.instagramLink,
      this.twitterLink,
      this.countrycode,
      this.commisionPercentage,
      this.driverCommisionPercentage,
      this.driverDeliveryRate,
      this.taxPercentage,
      this.rewardPoints,
      this.delaySeconds,
      this.s3BucketName,
      this.s3AccessKey,
      this.s3SecretAccessKey,
      this.s3Url,
      this.s3Region,
      this.imgRestaurant,
      this.imgGroccery});

  GeneralSetting.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    currency = json['currency'];
    currencyCode = json['currency_code'];
    serviceCharge = json['service_charge'];
    facebookLink = json['facebook_link'];
    instagramLink = json['instagram_link'];
    twitterLink = json['twitter_link'];
    countrycode = json['countrycode'];
    commisionPercentage = json['commision_percentage'];
    driverCommisionPercentage = json['driver_commision_percentage'];
    driverDeliveryRate = json['driver_delivery_rate'];
    taxPercentage = json['tax_percentage'];
    rewardPoints = json['reward_points'];
    delaySeconds = json['delay_seconds'];
    s3BucketName = json['s3_bucket_name'];
    s3AccessKey = json['s3_access_key'];
    s3SecretAccessKey = json['s3_secret_access_key'];
    s3Url = json['s3_url'];
    s3Region = json['s3_region'];
    imgRestaurant = json['img_restaurant'];
    imgGroccery = json['img_groccery'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    data['currency'] = currency;
    data['currency_code'] = currencyCode;
    data['service_charge'] = serviceCharge;
    data['facebook_link'] = facebookLink;
    data['instagram_link'] = instagramLink;
    data['twitter_link'] = twitterLink;
    data['countrycode'] = countrycode;
    data['commision_percentage'] = commisionPercentage;
    data['driver_commision_percentage'] = driverCommisionPercentage;
    data['driver_delivery_rate'] = driverDeliveryRate;
    data['tax_percentage'] = taxPercentage;
    data['reward_points'] = rewardPoints;
    data['delay_seconds'] = delaySeconds;
    data['s3_bucket_name'] = s3BucketName;
    data['s3_access_key'] = s3AccessKey;
    data['s3_secret_access_key'] = s3SecretAccessKey;
    data['s3_url'] = s3Url;
    data['s3_region'] = s3Region;
    data['img_restaurant'] = imgRestaurant;
    data['img_groccery'] = imgGroccery;
    return data;
  }
}
