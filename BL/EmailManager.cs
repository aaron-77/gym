using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SendGrid;
using SendGrid.Helpers.Mail;
using DTO.Dtos;
using System.Reflection.Metadata;
namespace BL
{
    public class EmailManager
    {

        public async Task<Response> sendEmail(EmailContent email) {
            Response response = null;
            try {
                var apiKey = "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";
                var client = new SendGridClient(apiKey);
                var from = new EmailAddress("yesquivelb@ucenfotec.ac.cr", "Fitness GYM");
                var subject = "Notificacion Cita";
                var to = new EmailAddress(email.recipient, "");
                var plainTextContent = email.message;
                var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent,email.htmlMessaje);
                response = await client.SendEmailAsync(msg);
            }
            catch(Exception ex) {
                string logMessage = $"[ERROR] Método: sendEmail | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Destinatario: {email?.recipient} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
            }
            
            return response;
        }
        public string createHtmlTemplate (string Saludo,string mensaje) {

            try
            {
                return "<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <title>Email</title>\r\n    <style>\r\n        body {\r\n            font-family: Arial, sans-serif;\r\n            margin: 0;\r\n            padding: 0;\r\n            background-color: #f4f4f4;\r\n        }\r\n        .email-container {\r\n            max-width: 600px;\r\n            margin: auto;\r\n            background-color: #ffffff;\r\n            padding: 20px;\r\n            border-radius: 8px;\r\n            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);\r\n        }\r\n        .header {\r\n            text-align: center;\r\n            padding: 20px 0;\r\n        }\r\n        .header img {\r\n            max-width: 100px;\r\n        }\r\n        .header h1 {\r\n            margin: 10px 0 0;\r\n            color: #333333;\r\n        }\r\n        .content {\r\n            padding: 20px 0;\r\n            text-align: center;\r\n        }\r\n        .content h2 {\r\n            color: #333333;\r\n        }\r\n        .content p {\r\n            color: #666666;\r\n            line-height: 1.6;\r\n        }\r\n        .button {\r\n            display: inline-block;\r\n            padding: 10px 20px;\r\n            margin: 20px 0;\r\n            background-color: #007BFF;\r\n            color: #ffffff;\r\n            text-decoration: none;\r\n            border-radius: 5px;\r\n        }\r\n        .button:hover {\r\n            background-color: #0056b3;\r\n        }\r\n        .footer {\r\n            text-align: center;\r\n            padding: 20px 0;\r\n            color: #999999;\r\n            font-size: 12px;\r\n        }\r\n    </style>\r\n</head>\r\n<body>\r\n    <div class=\"email-container\">\r\n        <div class=\"header\">\r\n            <img src=\"https://via.placeholder.com/100\" alt=\"Logo\">\r\n            <h1\">"+Saludo+"</h1>\r\n        </div>\r\n        <div class=\"content\">\r\n            <h2>" + mensaje + ",</h2>\r\n            <p>\r\n" + "Gracias por tu preferencia\r\n              </p>\r\n            <ul style=\"text-align: left;\">\r\n                <p>&copy; 2024 Fitness Gym. All rights reserved.</p>\r\n            <p></p>\r\n        </div>\r\n    </div>\r\n</body>\r\n</html>\r\n";
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: createHtmlTemplate | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                throw;
            }

        }
        public EmailContent buildHtmlEmail(string recipientP,string saludoP,string mensajeP) {
            try
            {
                string htmlTemplate = createHtmlTemplate(saludoP, mensajeP);
                EmailContent email = new EmailContent() { recipient = recipientP, message = mensajeP, htmlMessaje = htmlTemplate };
                return email;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: buildHtmlEmail | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Destinatario: {recipientP} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                throw;
            }

        } 
    }
}
