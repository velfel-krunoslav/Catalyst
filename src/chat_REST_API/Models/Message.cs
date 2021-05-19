using SignalR_chat_API.Interfaces;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace chat_SignalR.Models
{
    public class Message
    {
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int Id { get; set; }

    [Required]
    [DatabaseGenerated(DatabaseGeneratedOption.None)]
    public int ChatId { get; set; }

    [Required]
    public int FromId { get; set; }

    [Required]
    [Column(TypeName = "varchar(500)")]
    public string MessageText { get; set; }

    [Required]
    public DateTime Timestamp { get; set; }

    public bool unread { get; set; }

            public string toString()
        {
            return Id + " " + ChatId + " " + FromId + " "  + MessageText + " " + Timestamp + " " + unread;
        }
    }
}
