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
    public class ChatController : Controller
    {
        private databaseContext context = new databaseContext();
        /*
        [HttpGet("ProbaChats")]
        public IActionResult Proba()
        {
            return Ok("Radi");
        }

        [HttpGet("CountChats")]
        public int CountChats()
        {
            int broj = context.Chats.Count();
            return broj;
        }
        
        [HttpGet("CountChatsForUser")]
        public int CountChatsForUser(int id)
        {
            int broj = context.Chats.Where(u => (u.Id_Sender == id || u.Id_Reciever == id)).Select(u => new Chat { Id = u.Id, Id_Sender = u.Id_Sender, Id_Reciever = u.Id_Reciever }).Count();
            return broj;
        }
        */
        [HttpGet("GetChat")]
        public Chat GetChats(int id)
        {
            return context.Chats.Where(x => x.Id == id).FirstOrDefault();
        }
        
        [HttpGet("GetChats")]
        public List<Chat> GetChats()
        {
            var chat=context.Chats.Select(u => new Chat { Id = u.Id, Id_Sender=u.Id_Sender,Id_Reciever=u.Id_Reciever}).ToList();
            if (chat == null)
            {
                return null;
            }
            else
            {
                return chat;
            }
        }
        
        [HttpGet("GetChatsFromUserID")]
        public List<Chat> GetChatsFromUserID(int id)
        {
            var chat = context.Chats.Where(u => (u.Id_Sender == id || u.Id_Reciever == id)).Select(u => new Chat { Id = u.Id, Id_Sender = u.Id_Sender, Id_Reciever = u.Id_Reciever }).ToList();
            if (chat == null)
            {
                return null;
            }
            else
            {
                return chat;
            }
        }

        [HttpGet("GetChatBetweenUsers")]
        public int GetChatWihUserID(int UserID1, int UserID2)
        { 
            var chatID = context.Chats.Where(c=>((c.Id_Sender== UserID1 && c.Id_Reciever== UserID2) ||(c.Id_Sender == UserID2 && c.Id_Reciever == UserID1))).Select(c=>c.Id).FirstOrDefault();
            if (chatID == 0)
            {
                return 0;
            }
            else
            {
                return chatID;
            }
        }

        [HttpPost("AddChat")]
        public IActionResult AddChat([FromBody] Chat chatParam)
        {
            var isChatPresent = context.Chats.Where(c =>(c.Id_Sender==chatParam.Id_Sender&&c.Id_Reciever==chatParam.Id_Reciever) || (c.Id_Sender == chatParam.Id_Reciever && c.Id_Reciever == chatParam.Id_Sender));
            
            Chat chat = new Chat();
            chat.Id_Sender = chatParam.Id_Sender;
            chat.Id_Reciever = chatParam.Id_Reciever;

            if (!isChatPresent.Any())
            {
                context.Chats.Add(chat);
                context.SaveChanges();

                return Ok(chat);
            }
            else
            {
                chat.Id = -1;
                return Ok(chat);
            }
        }

        [HttpDelete("DeleteChat")]
        public IActionResult Delete(int id)
        {
            var chat = context.Chats.Where(x => x.Id == id).FirstOrDefault();
            if (chat == null)
            {
                return BadRequest(new { message = "ID of chat not present!" });
            }
            else
            {
                context.Chats.Remove(chat);
                context.SaveChanges();
                return Ok("Deleted chat:" + chat +"successfully");
            }
        }

    }
}
