// File: BL/Utils/EmailManager.cs
using MailKit.Net.Smtp;
using MailKit;
using MimeKit;
using System;
using DTO.Dtos;
namespace BL.Utils
{
    public class EmailManagerMailKit
    {
        private readonly string _smtpServer;
        private readonly int _smtpPort;
        private readonly string _username;
        private readonly string _password;

        public EmailManagerMailKit(string smtpServer, int smtpPort, string username, string password)
        {
            _smtpServer = smtpServer;
            _smtpPort = smtpPort;
            _username = username;
            _password = password;
        }

        public MimeMessage crearEmail(
            string fromName,
        string fromEmail,
         string toName,
          string toEmail,
           string subject,
            string body)
        {
            try
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress(fromName, fromEmail));
                message.To.Add(new MailboxAddress(toName, toEmail));
                message.Subject = subject;

                message.Body = new TextPart("plain")
                {
                    Text = body
                };

                return message;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: crearEmail | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | From: {fromEmail} To: {toEmail} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                throw;
            }
        }

        public DTO.Dtos.SmtpResponse EnviarEmail(MimeMessage message)
        {
            try
            {
                using (var client = new SmtpClient())
                {
                    client.Connect(_smtpServer, _smtpPort, MailKit.Security.SecureSocketOptions.StartTls);
                    client.Authenticate(_username, _password);

                    client.Send(message);
                    client.Disconnect(true);
                }

                return new DTO.Dtos.SmtpResponse(true, "Email enviado exitosamente.");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: EnviarEmail | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

                return new DTO.Dtos.SmtpResponse(false, ex.Message);
            }
        }
    }
}