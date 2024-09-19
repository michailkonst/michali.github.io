import spacy
import argparse
import math

MAX_WORDS = 8

spacy.prefer_gpu()

nlp = spacy.load("en_core_web_sm")

def generate_slug(title):
    doc = nlp(title)
    keywords = []
    entities = [ent.text.lower().replace(" ", "-") for ent in doc.ents]
    keywords.extend(entities)

    for token in doc:
        if not token.is_stop and token.pos_ in ['NOUN', 'VERB', 'ADJ']:
            keywords.append(token.text.lower().replace(" ", "-"))
    keywords = list(dict.fromkeys(keywords))

    if len(keywords) > MAX_WORDS:
        left_words_count = math.ceil(MAX_WORDS / 2)
        right_words_count = MAX_WORDS - left_words_count
        slug = "-".join(keywords[:left_words_count] + keywords[-right_words_count:])
    else:
        slug = "-".join(keywords)

    return slug

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a slug from a given title")
    parser.add_argument("title", type=str, help="The title to generate a slug for")
    args = parser.parse_args()
    slug = generate_slug(args.title)
    print(slug)