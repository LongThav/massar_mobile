class FashionModel {
    // bool successfully;
    int statusCode;
    List<Fashion> data;

    FashionModel({
        //  required this.successfully,
         this.statusCode = 200,
         this.data = const [],
    });

    factory FashionModel.fromJson(Map<String, dynamic> json) => FashionModel(
        // successfully: json["successfully"],
        statusCode: json["statusCode"],
        data: List<Fashion>.from(json["data"].map((x) => Fashion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        // "successfully": successfully,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Fashion {
    int id;
    String name;
    String sellerName;
    String price;
    String? rate;
    String image;
    String? discountPrice;
    String? fashionId;
    DateTime createdAt;
    DateTime updatedAt;

    Fashion({
        this.id = 9,
        this.name = "no-name",
        this.sellerName = "no-sellerName",
        this.price = "no-price",
        this.rate = "no-rate",
        this.image = "no-image",
        this.discountPrice = "no-discountPrice",
        this.fashionId = "no-FashionId",
        required this.createdAt,
        required this.updatedAt,
    });

    factory Fashion.fromJson(Map<String, dynamic> json) => Fashion(
        id: json["id"],
        name: json["name"],
        sellerName: json["seller_name"],
        price: json["price"],
        rate: json["rate"],
        image: json["image"],
        discountPrice: json["discount_price"],
        fashionId: json["fashion_id"],
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
        "fashion_id": fashionId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
