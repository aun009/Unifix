package com.unifix.unifix.controller;

import com.unifix.unifix.dto.ApiResponse;
import com.unifix.unifix.dto.FeedbackRequest;
import com.unifix.unifix.entity.Feedback;
import com.unifix.unifix.service.FeedbackService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/feedback")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class FeedbackController {
    
    private final FeedbackService feedbackService;
    
    @PostMapping
    public ResponseEntity<ApiResponse<Feedback>> submitFeedback(@Valid @RequestBody FeedbackRequest request) {
        log.info("=== FEEDBACK SUBMISSION START ===");
        log.info("Received feedback submission for: {}", request.getEmail());
        log.info("Request details - Name: {}, Email: {}, Message length: {}", 
                request.getName(), request.getEmail(), request.getMessage().length());
        
        try {
            log.info("Calling feedbackService.saveFeedback()...");
            Feedback savedFeedback = feedbackService.saveFeedback(request);
            log.info("Feedback service completed successfully. Saved feedback ID: {}", savedFeedback.getId());
            
            log.info("=== FEEDBACK SUBMISSION SUCCESS ===");
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Feedback submitted successfully!", savedFeedback));
                    
        } catch (Exception e) {
            log.error("=== FEEDBACK SUBMISSION FAILED ===");
            log.error("Error processing feedback submission: {}", e.getMessage(), e);
            log.error("Exception type: {}", e.getClass().getSimpleName());
            log.error("Full stack trace: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Failed to submit feedback. Please try again later."));
        }
    }
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<Feedback>>> getAllFeedback() {
        try {
            log.info("Fetching all feedback");
            
            List<Feedback> feedbackList = feedbackService.getAllFeedback();
            
            return ResponseEntity.ok(ApiResponse.success("Feedback retrieved successfully", feedbackList));
            
        } catch (Exception e) {
            log.error("Error fetching feedback: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Failed to fetch feedback. Please try again later."));
        }
    }
    
    @GetMapping("/health")
    public ResponseEntity<ApiResponse<String>> healthCheck() {
        log.info("Health check endpoint called");
        return ResponseEntity.ok(ApiResponse.success("Backend is healthy", "OK"));
    }
}
