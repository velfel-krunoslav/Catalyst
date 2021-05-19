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
    [Route("[controller]")]
    [ApiController]
    public class DatabaseController : ControllerBase
    {
        private databaseContext context = new databaseContext();

        [HttpGet("ProbaDatabaseController")]
        public IActionResult Proba()
        {
            return Ok("Radi");
        }
        
        [HttpGet("User_Chats")]
        public IActionResult User_Chats()
        {
            var user_chats = (from u in context.Users
                              from c in context.Chats
                              where u.Id.Equals(c.Id_Reciever) || u.Id.Equals(c.Id_Sender)
                              select new
                              {
                                  MessagesID = c.Id,
                                  FirstName = u.First_Name,
                                  LastName = u.Last_Name,
                                  MetaMaskAddress = u.metaMaskAddress,
                                  PrivateKey = u.privateKey,
                                  IDSender = c.Id_Sender,
                                  IDReciever = c.Id_Reciever,
                              }
                                        ).ToList();
            
            return Ok(user_chats);
        }

        [HttpGet("User_Chats_Messages")]
        public IActionResult User_Chats_Messages()
        {
            var user_chats = (from u in context.Users
                              from c in context.Chats
                              from m in context.Messages
                              where ((u.Id.Equals(c.Id_Reciever) || u.Id.Equals(c.Id_Sender))&&m.ChatId.Equals(c.Id))
                              select new
                              {
                                  MessagesID = c.Id,
                                  FirstName = u.First_Name,
                                  LastName = u.Last_Name,
                                  MetaMaskAddress = u.metaMaskAddress,
                                  PrivateKey = u.privateKey,
                                  IDSender = c.Id_Sender,
                                  IDReciever = c.Id_Reciever,
                                  ChatRead = m.statusRead,
                                  Message=m.MessageText,
                                  Date=m.Timestamp,

                              }
                                        ).ToList();

            return Ok(user_chats);
        }

        //IDUser1 metamask i privatni kljuc sa istim za drugog
        /*
        [HttpGet("UserToUserChatByUserID")]
        public IActionResult UserToUserChatByUserID(User user1, User user2)
        {



            return Ok(chat);
        }
        */

    }
}
