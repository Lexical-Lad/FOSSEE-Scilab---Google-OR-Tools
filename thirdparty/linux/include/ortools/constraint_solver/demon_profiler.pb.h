// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ortools/constraint_solver/demon_profiler.proto

#ifndef PROTOBUF_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto__INCLUDED
#define PROTOBUF_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 3000000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 3000000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/arena.h>
#include <google/protobuf/arenastring.h>
#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/metadata.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>
#include <google/protobuf/extension_set.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)

namespace operations_research {

// Internal implementation detail -- do not call these.
void protobuf_AddDesc_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();
void protobuf_AssignDesc_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();
void protobuf_ShutdownFile_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();

class ConstraintRuns;
class DemonRuns;

// ===================================================================

class DemonRuns : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:operations_research.DemonRuns) */ {
 public:
  DemonRuns();
  virtual ~DemonRuns();

  DemonRuns(const DemonRuns& from);

  inline DemonRuns& operator=(const DemonRuns& from) {
    CopyFrom(from);
    return *this;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const DemonRuns& default_instance();

  void Swap(DemonRuns* other);

  // implements Message ----------------------------------------------

  inline DemonRuns* New() const { return New(NULL); }

  DemonRuns* New(::google::protobuf::Arena* arena) const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const DemonRuns& from);
  void MergeFrom(const DemonRuns& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      bool deterministic, ::google::protobuf::uint8* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const {
    return InternalSerializeWithCachedSizesToArray(false, output);
  }
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  void InternalSwap(DemonRuns* other);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return _internal_metadata_.arena();
  }
  inline void* MaybeArenaPtr() const {
    return _internal_metadata_.raw_arena_ptr();
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // optional string demon_id = 1;
  void clear_demon_id();
  static const int kDemonIdFieldNumber = 1;
  const ::std::string& demon_id() const;
  void set_demon_id(const ::std::string& value);
  void set_demon_id(const char* value);
  void set_demon_id(const char* value, size_t size);
  ::std::string* mutable_demon_id();
  ::std::string* release_demon_id();
  void set_allocated_demon_id(::std::string* demon_id);

  // repeated int64 start_time = 2;
  int start_time_size() const;
  void clear_start_time();
  static const int kStartTimeFieldNumber = 2;
  ::google::protobuf::int64 start_time(int index) const;
  void set_start_time(int index, ::google::protobuf::int64 value);
  void add_start_time(::google::protobuf::int64 value);
  const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
      start_time() const;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
      mutable_start_time();

  // repeated int64 end_time = 3;
  int end_time_size() const;
  void clear_end_time();
  static const int kEndTimeFieldNumber = 3;
  ::google::protobuf::int64 end_time(int index) const;
  void set_end_time(int index, ::google::protobuf::int64 value);
  void add_end_time(::google::protobuf::int64 value);
  const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
      end_time() const;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
      mutable_end_time();

  // optional int64 failures = 4;
  void clear_failures();
  static const int kFailuresFieldNumber = 4;
  ::google::protobuf::int64 failures() const;
  void set_failures(::google::protobuf::int64 value);

  // @@protoc_insertion_point(class_scope:operations_research.DemonRuns)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  bool _is_default_instance_;
  ::google::protobuf::internal::ArenaStringPtr demon_id_;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 > start_time_;
  mutable int _start_time_cached_byte_size_;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 > end_time_;
  mutable int _end_time_cached_byte_size_;
  ::google::protobuf::int64 failures_;
  mutable int _cached_size_;
  friend void  protobuf_AddDesc_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();
  friend void protobuf_AssignDesc_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();
  friend void protobuf_ShutdownFile_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();

  void InitAsDefaultInstance();
  static DemonRuns* default_instance_;
};
// -------------------------------------------------------------------

class ConstraintRuns : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:operations_research.ConstraintRuns) */ {
 public:
  ConstraintRuns();
  virtual ~ConstraintRuns();

  ConstraintRuns(const ConstraintRuns& from);

  inline ConstraintRuns& operator=(const ConstraintRuns& from) {
    CopyFrom(from);
    return *this;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const ConstraintRuns& default_instance();

  void Swap(ConstraintRuns* other);

  // implements Message ----------------------------------------------

  inline ConstraintRuns* New() const { return New(NULL); }

  ConstraintRuns* New(::google::protobuf::Arena* arena) const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const ConstraintRuns& from);
  void MergeFrom(const ConstraintRuns& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      bool deterministic, ::google::protobuf::uint8* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const {
    return InternalSerializeWithCachedSizesToArray(false, output);
  }
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  void InternalSwap(ConstraintRuns* other);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return _internal_metadata_.arena();
  }
  inline void* MaybeArenaPtr() const {
    return _internal_metadata_.raw_arena_ptr();
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // optional string constraint_id = 1;
  void clear_constraint_id();
  static const int kConstraintIdFieldNumber = 1;
  const ::std::string& constraint_id() const;
  void set_constraint_id(const ::std::string& value);
  void set_constraint_id(const char* value);
  void set_constraint_id(const char* value, size_t size);
  ::std::string* mutable_constraint_id();
  ::std::string* release_constraint_id();
  void set_allocated_constraint_id(::std::string* constraint_id);

  // repeated int64 initial_propagation_start_time = 2;
  int initial_propagation_start_time_size() const;
  void clear_initial_propagation_start_time();
  static const int kInitialPropagationStartTimeFieldNumber = 2;
  ::google::protobuf::int64 initial_propagation_start_time(int index) const;
  void set_initial_propagation_start_time(int index, ::google::protobuf::int64 value);
  void add_initial_propagation_start_time(::google::protobuf::int64 value);
  const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
      initial_propagation_start_time() const;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
      mutable_initial_propagation_start_time();

  // repeated int64 initial_propagation_end_time = 3;
  int initial_propagation_end_time_size() const;
  void clear_initial_propagation_end_time();
  static const int kInitialPropagationEndTimeFieldNumber = 3;
  ::google::protobuf::int64 initial_propagation_end_time(int index) const;
  void set_initial_propagation_end_time(int index, ::google::protobuf::int64 value);
  void add_initial_propagation_end_time(::google::protobuf::int64 value);
  const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
      initial_propagation_end_time() const;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
      mutable_initial_propagation_end_time();

  // optional int64 failures = 4;
  void clear_failures();
  static const int kFailuresFieldNumber = 4;
  ::google::protobuf::int64 failures() const;
  void set_failures(::google::protobuf::int64 value);

  // repeated .operations_research.DemonRuns demons = 5;
  int demons_size() const;
  void clear_demons();
  static const int kDemonsFieldNumber = 5;
  const ::operations_research::DemonRuns& demons(int index) const;
  ::operations_research::DemonRuns* mutable_demons(int index);
  ::operations_research::DemonRuns* add_demons();
  ::google::protobuf::RepeatedPtrField< ::operations_research::DemonRuns >*
      mutable_demons();
  const ::google::protobuf::RepeatedPtrField< ::operations_research::DemonRuns >&
      demons() const;

  // @@protoc_insertion_point(class_scope:operations_research.ConstraintRuns)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  bool _is_default_instance_;
  ::google::protobuf::internal::ArenaStringPtr constraint_id_;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 > initial_propagation_start_time_;
  mutable int _initial_propagation_start_time_cached_byte_size_;
  ::google::protobuf::RepeatedField< ::google::protobuf::int64 > initial_propagation_end_time_;
  mutable int _initial_propagation_end_time_cached_byte_size_;
  ::google::protobuf::int64 failures_;
  ::google::protobuf::RepeatedPtrField< ::operations_research::DemonRuns > demons_;
  mutable int _cached_size_;
  friend void  protobuf_AddDesc_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();
  friend void protobuf_AssignDesc_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();
  friend void protobuf_ShutdownFile_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto();

  void InitAsDefaultInstance();
  static ConstraintRuns* default_instance_;
};
// ===================================================================


// ===================================================================

#if !PROTOBUF_INLINE_NOT_IN_HEADERS
// DemonRuns

// optional string demon_id = 1;
inline void DemonRuns::clear_demon_id() {
  demon_id_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline const ::std::string& DemonRuns::demon_id() const {
  // @@protoc_insertion_point(field_get:operations_research.DemonRuns.demon_id)
  return demon_id_.GetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline void DemonRuns::set_demon_id(const ::std::string& value) {
  
  demon_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:operations_research.DemonRuns.demon_id)
}
inline void DemonRuns::set_demon_id(const char* value) {
  
  demon_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:operations_research.DemonRuns.demon_id)
}
inline void DemonRuns::set_demon_id(const char* value, size_t size) {
  
  demon_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:operations_research.DemonRuns.demon_id)
}
inline ::std::string* DemonRuns::mutable_demon_id() {
  
  // @@protoc_insertion_point(field_mutable:operations_research.DemonRuns.demon_id)
  return demon_id_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline ::std::string* DemonRuns::release_demon_id() {
  // @@protoc_insertion_point(field_release:operations_research.DemonRuns.demon_id)
  
  return demon_id_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline void DemonRuns::set_allocated_demon_id(::std::string* demon_id) {
  if (demon_id != NULL) {
    
  } else {
    
  }
  demon_id_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), demon_id);
  // @@protoc_insertion_point(field_set_allocated:operations_research.DemonRuns.demon_id)
}

// repeated int64 start_time = 2;
inline int DemonRuns::start_time_size() const {
  return start_time_.size();
}
inline void DemonRuns::clear_start_time() {
  start_time_.Clear();
}
inline ::google::protobuf::int64 DemonRuns::start_time(int index) const {
  // @@protoc_insertion_point(field_get:operations_research.DemonRuns.start_time)
  return start_time_.Get(index);
}
inline void DemonRuns::set_start_time(int index, ::google::protobuf::int64 value) {
  start_time_.Set(index, value);
  // @@protoc_insertion_point(field_set:operations_research.DemonRuns.start_time)
}
inline void DemonRuns::add_start_time(::google::protobuf::int64 value) {
  start_time_.Add(value);
  // @@protoc_insertion_point(field_add:operations_research.DemonRuns.start_time)
}
inline const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
DemonRuns::start_time() const {
  // @@protoc_insertion_point(field_list:operations_research.DemonRuns.start_time)
  return start_time_;
}
inline ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
DemonRuns::mutable_start_time() {
  // @@protoc_insertion_point(field_mutable_list:operations_research.DemonRuns.start_time)
  return &start_time_;
}

// repeated int64 end_time = 3;
inline int DemonRuns::end_time_size() const {
  return end_time_.size();
}
inline void DemonRuns::clear_end_time() {
  end_time_.Clear();
}
inline ::google::protobuf::int64 DemonRuns::end_time(int index) const {
  // @@protoc_insertion_point(field_get:operations_research.DemonRuns.end_time)
  return end_time_.Get(index);
}
inline void DemonRuns::set_end_time(int index, ::google::protobuf::int64 value) {
  end_time_.Set(index, value);
  // @@protoc_insertion_point(field_set:operations_research.DemonRuns.end_time)
}
inline void DemonRuns::add_end_time(::google::protobuf::int64 value) {
  end_time_.Add(value);
  // @@protoc_insertion_point(field_add:operations_research.DemonRuns.end_time)
}
inline const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
DemonRuns::end_time() const {
  // @@protoc_insertion_point(field_list:operations_research.DemonRuns.end_time)
  return end_time_;
}
inline ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
DemonRuns::mutable_end_time() {
  // @@protoc_insertion_point(field_mutable_list:operations_research.DemonRuns.end_time)
  return &end_time_;
}

// optional int64 failures = 4;
inline void DemonRuns::clear_failures() {
  failures_ = GOOGLE_LONGLONG(0);
}
inline ::google::protobuf::int64 DemonRuns::failures() const {
  // @@protoc_insertion_point(field_get:operations_research.DemonRuns.failures)
  return failures_;
}
inline void DemonRuns::set_failures(::google::protobuf::int64 value) {
  
  failures_ = value;
  // @@protoc_insertion_point(field_set:operations_research.DemonRuns.failures)
}

// -------------------------------------------------------------------

// ConstraintRuns

// optional string constraint_id = 1;
inline void ConstraintRuns::clear_constraint_id() {
  constraint_id_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline const ::std::string& ConstraintRuns::constraint_id() const {
  // @@protoc_insertion_point(field_get:operations_research.ConstraintRuns.constraint_id)
  return constraint_id_.GetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline void ConstraintRuns::set_constraint_id(const ::std::string& value) {
  
  constraint_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:operations_research.ConstraintRuns.constraint_id)
}
inline void ConstraintRuns::set_constraint_id(const char* value) {
  
  constraint_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:operations_research.ConstraintRuns.constraint_id)
}
inline void ConstraintRuns::set_constraint_id(const char* value, size_t size) {
  
  constraint_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:operations_research.ConstraintRuns.constraint_id)
}
inline ::std::string* ConstraintRuns::mutable_constraint_id() {
  
  // @@protoc_insertion_point(field_mutable:operations_research.ConstraintRuns.constraint_id)
  return constraint_id_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline ::std::string* ConstraintRuns::release_constraint_id() {
  // @@protoc_insertion_point(field_release:operations_research.ConstraintRuns.constraint_id)
  
  return constraint_id_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline void ConstraintRuns::set_allocated_constraint_id(::std::string* constraint_id) {
  if (constraint_id != NULL) {
    
  } else {
    
  }
  constraint_id_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), constraint_id);
  // @@protoc_insertion_point(field_set_allocated:operations_research.ConstraintRuns.constraint_id)
}

// repeated int64 initial_propagation_start_time = 2;
inline int ConstraintRuns::initial_propagation_start_time_size() const {
  return initial_propagation_start_time_.size();
}
inline void ConstraintRuns::clear_initial_propagation_start_time() {
  initial_propagation_start_time_.Clear();
}
inline ::google::protobuf::int64 ConstraintRuns::initial_propagation_start_time(int index) const {
  // @@protoc_insertion_point(field_get:operations_research.ConstraintRuns.initial_propagation_start_time)
  return initial_propagation_start_time_.Get(index);
}
inline void ConstraintRuns::set_initial_propagation_start_time(int index, ::google::protobuf::int64 value) {
  initial_propagation_start_time_.Set(index, value);
  // @@protoc_insertion_point(field_set:operations_research.ConstraintRuns.initial_propagation_start_time)
}
inline void ConstraintRuns::add_initial_propagation_start_time(::google::protobuf::int64 value) {
  initial_propagation_start_time_.Add(value);
  // @@protoc_insertion_point(field_add:operations_research.ConstraintRuns.initial_propagation_start_time)
}
inline const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
ConstraintRuns::initial_propagation_start_time() const {
  // @@protoc_insertion_point(field_list:operations_research.ConstraintRuns.initial_propagation_start_time)
  return initial_propagation_start_time_;
}
inline ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
ConstraintRuns::mutable_initial_propagation_start_time() {
  // @@protoc_insertion_point(field_mutable_list:operations_research.ConstraintRuns.initial_propagation_start_time)
  return &initial_propagation_start_time_;
}

// repeated int64 initial_propagation_end_time = 3;
inline int ConstraintRuns::initial_propagation_end_time_size() const {
  return initial_propagation_end_time_.size();
}
inline void ConstraintRuns::clear_initial_propagation_end_time() {
  initial_propagation_end_time_.Clear();
}
inline ::google::protobuf::int64 ConstraintRuns::initial_propagation_end_time(int index) const {
  // @@protoc_insertion_point(field_get:operations_research.ConstraintRuns.initial_propagation_end_time)
  return initial_propagation_end_time_.Get(index);
}
inline void ConstraintRuns::set_initial_propagation_end_time(int index, ::google::protobuf::int64 value) {
  initial_propagation_end_time_.Set(index, value);
  // @@protoc_insertion_point(field_set:operations_research.ConstraintRuns.initial_propagation_end_time)
}
inline void ConstraintRuns::add_initial_propagation_end_time(::google::protobuf::int64 value) {
  initial_propagation_end_time_.Add(value);
  // @@protoc_insertion_point(field_add:operations_research.ConstraintRuns.initial_propagation_end_time)
}
inline const ::google::protobuf::RepeatedField< ::google::protobuf::int64 >&
ConstraintRuns::initial_propagation_end_time() const {
  // @@protoc_insertion_point(field_list:operations_research.ConstraintRuns.initial_propagation_end_time)
  return initial_propagation_end_time_;
}
inline ::google::protobuf::RepeatedField< ::google::protobuf::int64 >*
ConstraintRuns::mutable_initial_propagation_end_time() {
  // @@protoc_insertion_point(field_mutable_list:operations_research.ConstraintRuns.initial_propagation_end_time)
  return &initial_propagation_end_time_;
}

// optional int64 failures = 4;
inline void ConstraintRuns::clear_failures() {
  failures_ = GOOGLE_LONGLONG(0);
}
inline ::google::protobuf::int64 ConstraintRuns::failures() const {
  // @@protoc_insertion_point(field_get:operations_research.ConstraintRuns.failures)
  return failures_;
}
inline void ConstraintRuns::set_failures(::google::protobuf::int64 value) {
  
  failures_ = value;
  // @@protoc_insertion_point(field_set:operations_research.ConstraintRuns.failures)
}

// repeated .operations_research.DemonRuns demons = 5;
inline int ConstraintRuns::demons_size() const {
  return demons_.size();
}
inline void ConstraintRuns::clear_demons() {
  demons_.Clear();
}
inline const ::operations_research::DemonRuns& ConstraintRuns::demons(int index) const {
  // @@protoc_insertion_point(field_get:operations_research.ConstraintRuns.demons)
  return demons_.Get(index);
}
inline ::operations_research::DemonRuns* ConstraintRuns::mutable_demons(int index) {
  // @@protoc_insertion_point(field_mutable:operations_research.ConstraintRuns.demons)
  return demons_.Mutable(index);
}
inline ::operations_research::DemonRuns* ConstraintRuns::add_demons() {
  // @@protoc_insertion_point(field_add:operations_research.ConstraintRuns.demons)
  return demons_.Add();
}
inline ::google::protobuf::RepeatedPtrField< ::operations_research::DemonRuns >*
ConstraintRuns::mutable_demons() {
  // @@protoc_insertion_point(field_mutable_list:operations_research.ConstraintRuns.demons)
  return &demons_;
}
inline const ::google::protobuf::RepeatedPtrField< ::operations_research::DemonRuns >&
ConstraintRuns::demons() const {
  // @@protoc_insertion_point(field_list:operations_research.ConstraintRuns.demons)
  return demons_;
}

#endif  // !PROTOBUF_INLINE_NOT_IN_HEADERS
// -------------------------------------------------------------------


// @@protoc_insertion_point(namespace_scope)

}  // namespace operations_research

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_ortools_2fconstraint_5fsolver_2fdemon_5fprofiler_2eproto__INCLUDED
