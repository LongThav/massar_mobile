class DealModel {
    // bool successfully;
    int statusCode;
    List<Deal> data;

    DealModel({
        //  required this.successfully,
         this.statusCode = 200,
         this.data = const [],
    });

    factory DealModel.fromJson(Map<String, dynamic> json) => DealModel(
        // successfully: json["successfully"],
        statusCode: json["statusCode"],
        data: List<Deal>.from(json["data"].map((x) => Deal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        // "successfully": successfully,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Deal {
    int id;
    String name;
    String sellerName;
    String price;
    String? rate;
    String image;
    String? discountPrice;
    String? dealId;
    DateTime createdAt;
    DateTime updatedAt;

    Deal({
        this.id = 9,
        this.name = "no-name",
        this.sellerName = "no-sellerName",
        this.price = "no-price",
        this.rate = "no-rate",
        this.image = "no-image",
        this.discountPrice = "no-discountPrice",
        this.dealId = "no-delaId",
        required this.createdAt,
        required this.updatedAt,
    });

    factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        id: json["id"],
        name: json["name"],
        sellerName: json["seller_name"],
        price: json["price"],
        rate: json["rate"],
        image: json["image"],
        discountPrice: json["discount_price"],
        dealId: json["deal_id"],
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
        "deal_id": dealId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
