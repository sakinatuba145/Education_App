import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_bloc.dart';
import 'course_list.dart';
import 'course_model.dart';

class CourseScreen extends StatefulWidget {
  static String id='course_screen';

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController teacherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CourseBloc>(context, listen: false).fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CourseBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: bloc.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: CourseList(
              courses: bloc.courses,
              onDelete: (id) => bloc.deleteCourse(id),
              onTap: (course){
                Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Course Title"),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: teacherController,
                  decoration: const InputDecoration(labelText: "Teacher"),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    final course = CourseModel(
                      id: '',
                      title: titleController.text,
                      teacher: teacherController.text,
                      progress: 0.0,
                    );

                    bloc.addCourse(course);

                    titleController.clear();
                    teacherController.clear();
                  },
                  child: const Text("Add Course"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key,});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}
class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    return LessonScreen();
  }
}
