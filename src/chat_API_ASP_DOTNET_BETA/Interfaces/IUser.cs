using chat_SignalR.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_chat_API.Interfaces
{
    public interface IUser
    {
        User GetUser(int? id);
        IQueryable<User> GetUsers { get; }
        void Save(User user);
        void DeleteUser(int? id);
    }
}
