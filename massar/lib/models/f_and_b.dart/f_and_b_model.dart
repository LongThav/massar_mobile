class FANBModel {
    // bool successfully;
    int statusCode;
    List<FANDB> data;

    FANBModel({
        //  required this.successfully,
         this.statusCode = 200,
         this.data = const [],
    });

    factory FANBModel.fromJson(Map<String, dynamic> json) => FANBModel(
        // successfully: json["successfully"],
        statusCode: json["statusCode"],
        data: List<FANDB>.from(json["data"].map((x) => FANDB.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        // "successfully": successfully,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class FANDB {
    int id;
    String name;
    String sellerName;
    String price;
    String? rate;
    String image;
    String? discountPrice;
    String? fandbId;
    DateTime createdAt;
    DateTime updatedAt;

    FANDB({
        this.id = 9,
        this.name = "no-name",
        this.sellerName = "no-sellerName",
        this.price = "no-price",
        this.rate = "no-rate",
        this.image = "no-image",
        this.discountPrice = "no-discountPrice",
        this.fandbId = "no-electronicId",
        required this.createdAt,
        required this.updatedAt,
    });

    factory FANDB.fromJson(Map<String, dynamic> json) => FANDB(
        id: json["id"],
        name: json["name"],
        sellerName: json["seller_name"],
        price: json["price"],
        rate: json["rate"],
        image: json["image"],
        discountPrice: json["discount_price"],
        fandbId: json["f&b_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "seller_name": sellerName,
        "price": price,
        "rate": rate,
        "image": image,
        "discount_price": discountPrice,
        "f&b_id": fandbId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
