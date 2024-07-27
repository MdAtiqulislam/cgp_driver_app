import 'package:cgp_driver_app/app/modules/messaging/controllers/messaging_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'message_bubble.dart';

class MessagingView extends GetView<MessagingController> {
  const MessagingView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.fetchMessages(senderId);

    return SafeArea(
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const CustomCircleAvatar(
                  height: 30,
                  width: 30,
                  image: "",
                ),
                SizedBox(
                  width: AppDimensions.contentPadding.w,
                ),
                HeaderText(text: controller.chatWith.value)
              ],
            ),
          ),
          body:Obx(()=> Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (controller.messages.isEmpty) {
                        return const Center(child: Text('No messages'));
                      } else {
                        return ListView.builder(
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            final message = controller.messages[index];
                            // final isSender = message.senderId == senderId;

                            return MessageBubble(
                              message: message.message??"",
                              isSender: message.senderId==controller.rider.value.userId,
                              timestamp: message.updatedAt??DateTime.now(),
                            );
                          },
                        );
                      }
                    }),
                  ),
                 controller.disableChat.value
                     ?Container(
                   padding: const EdgeInsets.all(8),
                   child: const HeaderText(text: "This chat is disabled",color: Colors.red,),
                 )
                     : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.messageController,
                            decoration: InputDecoration(
                              hintText: 'Enter your message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            controller.sendMessage();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if(controller.isLoading.value)const LoadingScreen()
            ],
          ),),
        ),
      ),
    );
  }
}
