package com.unifix.unifix.service;

import com.unifix.unifix.entity.Feedback;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {
    
    private final JavaMailSender mailSender;
    
    @Value("${app.email.recipient:arunmahajan9240@gmail.com}")
    private String recipientEmail;


    @Value("${app.email.from:noreply@unifix.com}")
    private String fromEmail;
    
    public void sendFeedbackEmail(Feedback feedback) {
        try {
            // Check if email is configured
            if (mailSender == null) {
                log.info("Email service not configured, skipping email notification");
                return;
            }
            
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(recipientEmail);
            message.setSubject("New Feedback from UniFix - " + feedback.getName());
            
            String emailBody = String.format("""
                New feedback received from UniFix website:
                
                Name: %s
                Email: %s
                Message: %s
                
                Submitted at: %s
                
                ---
                This is an automated message from UniFix feedback system.
                """, 
                feedback.getName(),
                feedback.getEmail(),
                feedback.getMessage(),
                feedback.getCreatedAt()
            );
            
            message.setText(emailBody);
            
            mailSender.send(message);
            log.info("Feedback email sent successfully to: {}", recipientEmail);
            
        } catch (Exception e) {
            log.error("Failed to send feedback email: {}", e.getMessage(), e);
            // Don't throw exception to avoid breaking the feedback submission
        }
    }
}
