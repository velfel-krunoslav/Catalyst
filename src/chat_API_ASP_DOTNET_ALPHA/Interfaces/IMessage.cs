using chat_SignalR.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_chat_API.Interfaces
{
    public interface IMessage
    {
        Message GetMessage(int? id);
        IQueryable<Message> GetMessages { get; }
        void Save(Message message);
        void DeleteMessage(int? id);
    }
}
