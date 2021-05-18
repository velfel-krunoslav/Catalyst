using chat_SignalR.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SignalR_chat_API.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_chat_API.Controllers
{
        [ApiController]
        [Route("[controller]")]
        public class MessageController : Controller
        {
            private databaseContext context = new databaseContext();

            [HttpGet("ProbaMessages")]
            public IActionResult Proba()
            {
                return Ok("Radi");
            }

            [HttpGet("CountMessages")]
            public int CountChats()
            {
                int broj = context.Chats.Count();
                return broj;
            }

            [HttpGet("GetMessage")]
            public Message GetMessage(int id)
            {
                return context.Messages.Where(x => x.Id == id).FirstOrDefault();
            }

            [HttpGet("GetAllMessages")]
            public List<Message> GetAllMessages()
            {
                var chat = context.Messages.Select(m => new Message { Id = m.Id, FromId=m.FromId,ChatId=m.ChatId,MessageText=m.MessageText,Timestamp=m.Timestamp,statusRead=m.statusRead }).ToList();
                if (chat == null)
                {
                    return null;
                }
                else
                {
                    return chat;
                }
            }

        [HttpGet("GetAllMessagesFromChatID")]
        public List<Message> GetAllMessagesFromChat(int messageChatID)
        {
            var chat = context.Messages.Where(x => x.ChatId == messageChatID).OrderBy(m=>m.Timestamp).ToList();

            if (chat == null)
            {
                return null;
            }
            else
            {
                return chat;
            }
        }

        [HttpGet("GetLatestMessageFromChatID")]
        public IActionResult GetLatestMessageFromSenderID(int chatID)
        {
            var max = context.Messages.Where(x => x.ChatId == chatID).Max(x => x.Id);
            var result = context.Messages.Where(x => x.Id == max);

            if (result == null)
            {
                return null;
            }
            else
            {
                return Ok(result);
            }
        }

        [HttpGet("ChangeStatusRead")]
        public void ChangeStatusRead(int IDMessage,bool status)
        {
            Message result = context.Messages.Where(x => x.Id == IDMessage).FirstOrDefault();

            result.statusRead = status;
            context.SaveChanges();
        }


        [HttpPost("AddMessage")]
            public IActionResult AddMessage([FromBody] Message messageParam)
            {
            Console.Out.WriteLine("DEBUG STARTS HERE *******");
            Console.Out.WriteLine(messageParam.toString());
                var isMessagePresent = context.Messages.Where(m => m.Id == messageParam.Id&&m.FromId==messageParam.FromId&&m.MessageText==messageParam.MessageText&&m.Timestamp==messageParam.Timestamp&&m.statusRead==messageParam.statusRead);
                if (!isMessagePresent.Any())
                {
                    Message message = new Message();
                    message.FromId = messageParam.FromId;
                    message.ChatId = messageParam.ChatId;
                    message.MessageText = messageParam.MessageText;
                    message.Timestamp = messageParam.Timestamp;
                    message.statusRead = messageParam.statusRead;


                context.Messages.Add(message);
                    context.SaveChanges();

                    return Ok(message);
                }
                else
                {
                    return BadRequest(new { message = "Message already exists!" });
                }
            }

            [HttpDelete("DeleteMessage")]
            public IActionResult Delete(int id)
            {
                var message = context.Messages.Where(x => x.Id == id).FirstOrDefault();
                if (message == null)
                {
                    return BadRequest(new { message = "ID of message not present!" });
                }
                else
                {
                    context.Messages.Remove(message);
                    context.SaveChanges();
                    return Ok("Deleted chat:" + message + "successfully");
                }
            }

        }
    }
