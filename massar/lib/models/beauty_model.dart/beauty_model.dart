class BeautyModel {
    // bool successfully;
    int statusCode;
    List<Beauty> data;

    BeautyModel({
        //  required this.successfully,
         this.statusCode = 200,
         this.data = const [],
    });

    factory BeautyModel.fromJson(Map<String, dynamic> json) => BeautyModel(
        // successfully: json["successfully"],
        statusCode: json["statusCode"],
        data: List<Beauty>.from(json["data"].map((x) => Beauty.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        // "successfully": successfully,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Beauty {
    int id;
    String name;
    String sellerName;
    String price;
    String? rate;
    String image;
    String? discountPrice;
    String? beautyId;
    DateTime createdAt;
    DateTime updatedAt;

    Beauty({
        this.id = 9,
        this.name = "no-name",
        this.sellerName = "no-sellerName",
        this.price = "no-price",
        this.rate = "no-rate",
        this.image = "no-image",
        this.discountPrice = "no-discountPrice",
        this.beautyId = "no-electronicId",
        required this.createdAt,
        required this.updatedAt,
    });

    factory Beauty.fromJson(Map<String, dynamic> json) => Beauty(
        id: json["id"],
        name: json["name"],
        sellerName: json["seller_name"],
        price: json["price"],
        rate: json["rate"],
        image: json["image"],
        discountPrice: json["discount_price"],
        beautyId: json["beauty_id"],
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
        "beauty_id": beautyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
