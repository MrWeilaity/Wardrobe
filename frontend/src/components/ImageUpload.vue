<template>
  <div class="image-upload">
    <div v-if="imageUrl" class="image-preview">
      <img :src="imageUrl" alt="Preview" />
      <button @click="removeImage" class="remove-btn" type="button">✕</button>
    </div>
    <div v-else class="upload-placeholder" @click="triggerUpload">
      <input 
        ref="fileInput" 
        type="file" 
        accept="image/*" 
        @change="handleFileChange"
        style="display: none"
      />
      <div class="upload-icon">📷</div>
      <p>点击上传图片</p>
      <p class="hint">支持 JPG, PNG, GIF（最大5MB）</p>
    </div>
    <div v-if="uploading" class="uploading">
      <div class="spinner"></div>
      <p>上传中...</p>
    </div>
    <div v-if="error" class="error-message">{{ error }}</div>
  </div>
</template>

<script>
import axios from '../api/axios'

export default {
  name: 'ImageUpload',
  props: {
    modelValue: {
      type: String,
      default: ''
    }
  },
  emits: ['update:modelValue'],
  data() {
    return {
      uploading: false,
      error: ''
    }
  },
  computed: {
    imageUrl() {
      return this.modelValue
    }
  },
  methods: {
    triggerUpload() {
      this.$refs.fileInput.click()
    },
    async handleFileChange(event) {
      const file = event.target.files[0]
      if (!file) return

      // Validate file type
      if (!file.type.startsWith('image/')) {
        this.error = '只能上传图片文件'
        return
      }

      // Validate file size (5MB)
      if (file.size > 5 * 1024 * 1024) {
        this.error = '图片大小不能超过5MB'
        return
      }

      this.error = ''
      this.uploading = true

      try {
        const formData = new FormData()
        formData.append('file', file)

        const response = await axios.post('/upload/image', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        this.$emit('update:modelValue', response.data.url)
      } catch (error) {
        console.error('Upload failed:', error)
        this.error = '上传失败：' + (error.response?.data || error.message)
      } finally {
        this.uploading = false
        // Reset file input
        event.target.value = ''
      }
    },
    removeImage() {
      this.$emit('update:modelValue', '')
    }
  }
}
</script>

<style scoped>
.image-upload {
  position: relative;
}

.image-preview {
  position: relative;
  width: 100%;
  height: 200px;
  border-radius: 10px;
  overflow: hidden;
  border: 2px solid var(--border-color);
}

.image-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.remove-btn {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.6);
  color: white;
  border: none;
  cursor: pointer;
  font-size: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.3s;
}

.remove-btn:hover {
  background-color: rgba(0, 0, 0, 0.8);
}

.upload-placeholder {
  width: 100%;
  height: 200px;
  border: 2px dashed var(--border-color);
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  background-color: var(--background);
}

.upload-placeholder:hover {
  border-color: var(--primary-color);
  background-color: white;
}

.upload-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.upload-placeholder p {
  margin: 4px 0;
  color: var(--text-primary);
}

.hint {
  font-size: 0.85rem;
  color: var(--text-secondary);
}

.uploading {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.9);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 10px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--border-color);
  border-top-color: var(--primary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 12px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-message {
  margin-top: 8px;
  padding: 8px 12px;
  background-color: #FFE8E8;
  color: #D8000C;
  border-radius: 6px;
  font-size: 0.9rem;
}
</style>
