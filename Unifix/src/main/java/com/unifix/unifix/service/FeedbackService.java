package com.unifix.unifix.service;

import com.unifix.unifix.dto.FeedbackRequest;
import com.unifix.unifix.entity.Feedback;
import com.unifix.unifix.repository.FeedbackRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class FeedbackService {
    
    private final FeedbackRepository feedbackRepository;
    private final EmailService emailService;
    
    public Feedback saveFeedback(FeedbackRequest request) {
        log.info("Starting to save feedback for: {}", request.getEmail());
        try {
            log.info("Creating Feedback entity with name: {}, email: {}", request.getName(), request.getEmail());
            Feedback feedback = new Feedback(
                request.getName(),
                request.getEmail(),
                request.getMessage()
            );

            log.info("Attempting to save feedback to database...");
            Feedback savedFeedback = feedbackRepository.save(feedback);
            log.info("Feedback saved successfully with ID: {}", savedFeedback.getId());
            
            // Send email notification
            log.info("Attempting to send email notification...");
            try {
                emailService.sendFeedbackEmail(savedFeedback);
                log.info("Email notification sent successfully");
            } catch (Exception emailException) {
                log.error("Failed to send email notification: {}", emailException.getMessage(), emailException);
                // Don't fail the whole operation if email fails
            }

            return savedFeedback;
            
        } catch (Exception e) {
            log.error("Error saving feedback: {}", e.getMessage(), e);
            log.error("Stack trace: ", e);
            throw new RuntimeException("Failed to save feedback", e);
        }
    }
    
    public List<Feedback> getAllFeedback() {
        try {
            return feedbackRepository.findAllByOrderByCreatedAtDesc();
        } catch (Exception e) {
            log.error("Error fetching feedback: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to fetch feedback", e);
        }
    }
}