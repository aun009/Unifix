#!/bin/bash
# Run NLP Script with SpaCy

echo "Running NLP script with SpaCy..."

python -c "import spacy; nlp = spacy.load(en_core_web_sm); doc = nlp(Hello, SpaCy!); print([token.text for token in doc])"

echo "SpaCy NLP script run successfully!"

