---
name: docx
description: "Use when creating, editing, reading, or analyzing .docx files, working with tracked changes, adding comments, or extracting text from Word documents."
source: anthropics/skills
license: Apache-2.0
---

# DOCX Processing

## When to Use

- 创建新的 Word 文档
- 编辑现有文档内容
- 处理修订（tracked changes）
- 提取文档文本内容
- 将文档转换为图片/PDF

## Workflow Decision Tree

- **Reading/Analyzing**: Use text extraction or raw XML access
- **Creating New Document**: Use docx-js (JavaScript)
- **Editing Existing**: Use OOXML editing or redlining workflow

## Reading Content

### Text Extraction with Pandoc
```bash
# Convert to markdown with tracked changes
pandoc --track-changes=all file.docx -o output.md
```

### Raw XML Access
```bash
# Unpack document
unzip document.docx -d unpacked/
# Key files:
# word/document.xml - Main content
# word/comments.xml - Comments
# word/media/ - Images
```

## Creating New Documents (docx-js)

```javascript
import { Document, Paragraph, TextRun, Packer } from 'docx';
import fs from 'fs';

const doc = new Document({
  sections: [{
    children: [
      new Paragraph({
        children: [
          new TextRun({ text: "Hello ", bold: true }),
          new TextRun({ text: "World", italics: true })
        ]
      })
    ]
  }]
});

const buffer = await Packer.toBuffer(doc);
fs.writeFileSync('document.docx', buffer);
```

## Editing Existing Documents

### Simple Edits
1. Unpack: `unzip doc.docx -d unpacked/`
2. Edit `word/document.xml`
3. Repack: `cd unpacked && zip -r ../edited.docx .`

### Tracked Changes (Redlining)
For professional documents, use tracked changes:

```xml
<!-- Deletion -->
<w:del w:author="Author" w:date="2025-01-01T00:00:00Z">
  <w:r><w:delText>old text</w:delText></w:r>
</w:del>

<!-- Insertion -->
<w:ins w:author="Author" w:date="2025-01-01T00:00:00Z">
  <w:r><w:t>new text</w:t></w:r>
</w:ins>
```

## Converting to Images

```bash
# DOCX to PDF
soffice --headless --convert-to pdf document.docx

# PDF to images
pdftoppm -jpeg -r 150 document.pdf page
```

## Best Practices

- Use Pandoc for text extraction
- Use docx-js for creating new documents
- For legal/business docs, always use tracked changes
- Preserve original RSIDs when editing

## Quick Reference

| 操作 | 工具/命令 |
|------|----------|
| 提取文本 | `pandoc --track-changes=all file.docx -o output.md` |
| 创建文档 | docx-js (JavaScript) |
| 编辑文档 | 解压 → 编辑 XML → 重新打包 |
| 转PDF | `soffice --headless --convert-to pdf document.docx` |

## Common Mistakes

- ❌ 直接编辑二进制文件 → ✅ 解压后编辑 XML
- ❌ 创建文档用 Python → ✅ 用 docx-js (JavaScript)
- ❌ 编辑时不保留修订 → ✅ 法律/商务文档必须用 tracked changes
