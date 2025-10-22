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
        try {
            Feedback feedback = new Feedback(
                request.getName(),
                request.getEmail(),
                request.getMessage()
            );


            Feedback savedFeedback = feedbackRepository.save(feedback);
            log.info("Feedback saved successfully with ID: {}", savedFeedback.getId());
            
            // Send email notification
            emailService.sendFeedbackEmail(savedFeedback);

            return savedFeedback;
            
        } catch (Exception e) {
            log.error("Error saving feedback: {}", e.getMessage(), e);
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