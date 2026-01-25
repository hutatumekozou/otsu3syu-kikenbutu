import re
import json
import os

# Configuration
INPUT_FILE = "raw_questions_class2.txt"
OUTPUT_DIR = "Resources/questions"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Topic mapping
TOPICS = [
    (1, 10, "class2_genre1", "危険物の性状"),
    (11, 20, "class2_genre2", "火災予防と貯蔵"),
    (21, 30, "class2_genre3", "消火方法"),
    (31, 40, "class2_genre4", "硫化リン"),
    (41, 50, "class2_genre5", "赤リン"),
    (51, 60, "class2_genre6", "硫黄"),
    (61, 70, "class2_genre7", "鉄粉"),
    (71, 80, "class2_genre8", "金属粉・マグネシウム"),
    (81, 90, "class2_genre9", "引火性固体"),
    (91, 100, "class2_genre10", "法令・指定数量"),
]

def parse_questions(text):
    questions = []
    # Split by "第X問" but keep the delimiter to know where it starts
    parts = re.split(r'(第\d+問)', text)
    
    current_q = {}
    
    for part in parts:
        part = part.strip()
        if not part: continue
        
        if re.match(r'第\d+問', part):
            # If we have a current question loaded, verify completion before starting new (though logic below handles it by processing body next)
            pass
        else:
            # This is the body of the question
            lines = part.split('\n')
            question_text_lines = []
            choices = []
            answer_label = ""
            explanation = ""
            mode = "question"
            
            for line in lines:
                line = line.strip()
                if not line: continue
                
                if line.startswith("A.") or line.startswith("A ") or line.startswith("A．"):
                    mode = "choices"
                    choices.append("A. " + line[2:].strip())
                elif line.startswith("B.") or line.startswith("B ") or line.startswith("B．"):
                     choices.append("B. " + line[2:].strip())
                elif line.startswith("C.") or line.startswith("C ") or line.startswith("C．"):
                     choices.append("C. " + line[2:].strip())
                elif line.startswith("D.") or line.startswith("D ") or line.startswith("D．"):
                     choices.append("D. " + line[2:].strip())
                elif line.startswith("正解：") or line.startswith("正解:"):
                    mode = "answer"
                    answer_label = line.split("：")[-1].split(":")[-1].strip()
                    # cleanup answer label if it has extra text like "C (description)"
                    answer_label = answer_label[0] 
                elif line.startswith("解説：") or line.startswith("解説:"):
                    mode = "explanation"
                    explanation = line.split("：")[-1].split(":")[-1].strip()
                else:
                    if mode == "question":
                        question_text_lines.append(line)
                    elif mode == "explanation":
                        explanation += "\n" + line
                    # Note: Multiline choices are not handled well here but usually choices are single line
            
            # Construct question object
            q_idx = len(questions) # 0-based index for the whole set
            
            # Map Answer Label to Index
            mapper = {'A': 0, 'B': 1, 'C': 2, 'D': 3}
            answer_index = mapper.get(answer_label, 0)
            
            q_obj = {
                "id": f"class2_q{len(questions)+1}",
                "category": "temp", # will update later
                "question": "\n".join(question_text_lines),
                "choices": choices,
                "answer_index": answer_index,
                "answer_label": answer_label,
                "explanation": explanation,
                "image_name": None
            }
            questions.append(q_obj)
            
    return questions

def main():
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        text = f.read()
    
    all_questions = parse_questions(text)
    print(f"Parsed {len(all_questions)} questions.")

    for start_q, end_q, filename, topic_name in TOPICS:
        # subset questions (1-indexed start/end)
        # Python list is 0-indexed, so start_q-1 to end_q
        subset = all_questions[start_q-1 : end_q] 
        
        # Start numbering from 1 for each file? No, usually distinct IDs
        # But category needs to be set
        
        final_list = []
        for q in subset:
            q["category"] = topic_name
            final_list.append(q)
            
        output_path = os.path.join(OUTPUT_DIR, f"{filename}.json")
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(final_list, f, indent=4, ensure_ascii=False)
        print(f"Wrote {len(final_list)} questions to {output_path}")

if __name__ == "__main__":
    main()
