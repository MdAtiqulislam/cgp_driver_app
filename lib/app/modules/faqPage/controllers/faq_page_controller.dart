import 'package:get/get.dart';

import '../../../../services/api_endpoints.dart';
import '../../../../services/remote_services.dart';
import '../models/f_a_q_list_model.dart';

class FaqPageController extends GetxController {
  var isLoading=false.obs;
  var faqItems = <FAQItem>[].obs;
  var faqListModel=FaqListModel().obs;

  @override
  void onInit() async{
    super.onInit();

    await getFAQs();
    faqItems.addAll([
      FAQItem(question: "What is the return policy?", answer: "You can return any item within 30 days of purchase. Please ensure the item is in its original condition and packaging."),
      FAQItem(question: "How do I track my order?", answer: "Once your order has been shipped, you will receive a tracking number via email. You can use this number on our website to track your order."),
      FAQItem(question: "Can I change my shipping address after placing an order?", answer: "Yes, you can change your shipping address within 24 hours of placing your order by contacting our customer service."),
    ]);
  }

  void toggleFAQ(int index) {
    faqItems[index].isExpanded = !faqItems[index].isExpanded;
    faqItems.refresh(); // Refresh the list to update the UI
  }

  Future<void>  getFAQs() async{
    faqItems.value=[];
    isLoading.value=true;
    var link="${APIEndPoints.baseUrlMessaging}${APIEndPoints.faqEndPoint}";
    var parameters={
      "type":"rider"
    };
    try {
      var response=await RemoteServices.chatGetRequest(link:link ,parameters: parameters);
      if(response!=null){
        faqListModel.value=FaqListModel.fromJson(response);
        addFAQItems();
      }
    } finally {
      isLoading.value=false;
    }
  }

  void addFAQItems() {
    faqListModel.value.data?.data?.forEach((value){
      faqItems.add(FAQItem(question: value.faqQuestion??"", answer: value.faqAns??"",isExpanded: false));
    });
  }
}

class FAQItem {
  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  String question;
  String answer;
  bool isExpanded;
}