using chat_SignalR.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_chat_API.Interfaces
{
    public interface IChat
    {
        Chat GetChat(int? id);
        IQueryable<Chat> GetChats { get; }
        void Save(Chat chat);
        void DeleteChat(int? id);
    }
}
