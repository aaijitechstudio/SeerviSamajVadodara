import '../domain/models/committee_model.dart';

class CommitteeData {
  // Executive Committee Members (कार्यकारणी कमीटी)
  static List<CommitteeModel> get executiveCommittee => [
        // अध्यक्ष (President)
        CommitteeModel(
          id: 'president_1',
          name: 'मांगीलाल',
          position: 'अध्यक्ष',
          positionEn: 'President',
          fatherName: 'खरतारामजी काग',
          location: 'कालापीपल ढाणी',
          gotra: 'काग',
          phone: '', // To be added later
          email: null,
          imageUrl: null, // Placeholder will be used
          order: 1,
        ),

        // उपाध्यक्ष (Vice President)
        CommitteeModel(
          id: 'vice_president_1',
          name: 'कालूराम',
          position: 'उपाध्यक्ष',
          positionEn: 'Vice President',
          fatherName: 'भीखारामजी परिहार',
          location: 'गुड़ा केशरसिंह',
          gotra: 'परिहार',
          phone: '',
          email: null,
          imageUrl: null,
          order: 2,
        ),

        CommitteeModel(
          id: 'vice_president_2',
          name: 'सुरेशकुमार',
          position: 'उपाध्यक्ष',
          positionEn: 'Vice President',
          fatherName: 'केसारामजी सोलंकी',
          location: 'भालेलाव',
          gotra: 'सोलंकी',
          phone: '',
          email: null,
          imageUrl: null,
          order: 3,
        ),

        // कोषाध्यक्ष (Treasurer)
        CommitteeModel(
          id: 'treasurer_1',
          name: 'नारायणलाल',
          position: 'कोषाध्यक्ष',
          positionEn: 'Treasurer',
          fatherName: 'पेमारामजी राठोड',
          location: 'गुड़ा केशरसिंह',
          gotra: 'राठोड',
          phone: '',
          email: null,
          imageUrl: null,
          order: 4,
        ),

        // स. कोषाध्यक्ष (Assistant Treasurer)
        CommitteeModel(
          id: 'asst_treasurer_1',
          name: 'चुनीलाल',
          position: 'स. कोषाध्यक्ष',
          positionEn: 'Assistant Treasurer',
          fatherName: 'भिकारामजी परिहार',
          location: 'गुड़ा केशरसिंह',
          gotra: 'परिहार',
          phone: '',
          email: null,
          imageUrl: null,
          order: 5,
        ),

        CommitteeModel(
          id: 'asst_treasurer_2',
          name: 'रूगाराम',
          position: 'स. कोषाध्यक्ष',
          positionEn: 'Assistant Treasurer',
          fatherName: 'पुकारामजी पवार',
          location: 'गादाणा',
          gotra: 'पवार',
          phone: '',
          email: null,
          imageUrl: null,
          order: 6,
        ),

        // सचिव (Secretary)
        CommitteeModel(
          id: 'secretary_1',
          name: 'मुकेश',
          position: 'सचिव',
          positionEn: 'Secretary',
          fatherName: 'दिपारामजी सोयल',
          location: 'धनला',
          gotra: 'सोयल',
          phone: '',
          email: null,
          imageUrl: null,
          imageStoragePath: 'committee_members/mukesh_07.png',
          order: 7,
        ),

        // स. सचिव (Assistant Secretary)
        CommitteeModel(
          id: 'asst_secretary_1',
          name: 'जैपाराम',
          position: 'स. सचिव',
          positionEn: 'Assistant Secretary',
          fatherName: 'भानारामजी काग',
          location: 'धनला',
          gotra: 'काग',
          phone: '',
          email: null,
          imageUrl: null,
          order: 8,
        ),

        // सलाकार (Advisor)
        CommitteeModel(
          id: 'advisor_1',
          name: 'प्रकाश',
          position: 'सलाकार',
          positionEn: 'Advisor',
          fatherName: 'मेगारामजी वर्फा',
          location: 'जेतपुरा',
          gotra: 'वर्फा',
          phone: '',
          email: null,
          imageUrl: null,
          order: 9,
        ),

        // स. सलाकार (Assistant Advisor)
        CommitteeModel(
          id: 'asst_advisor_1',
          name: 'नवीनकुमार',
          position: 'स. सलाकार',
          positionEn: 'Assistant Advisor',
          fatherName: 'गणेशरामजी सेपटा',
          location: 'देवली आऊवा',
          gotra: 'सेपटा',
          phone: '',
          email: null,
          imageUrl: null,
          order: 10,
        ),

        // वयवस्थापक (Manager)
        CommitteeModel(
          id: 'manager_1',
          name: 'भरतकुमार',
          position: 'वयवस्थापक',
          positionEn: 'Manager',
          fatherName: 'मोतीलालजी गेहलोत',
          location: 'खरोकड़ा',
          gotra: 'गेहलोत',
          phone: '',
          email: null,
          imageUrl: null,
          order: 11,
        ),

        // स. वयवस्थापक (Assistant Manager)
        CommitteeModel(
          id: 'asst_manager_1',
          name: 'लादूराम',
          position: 'स. वयवस्थापक',
          positionEn: 'Assistant Manager',
          fatherName: 'हिरारामजी काग',
          location: 'केरला',
          gotra: 'काग',
          phone: '',
          email: null,
          imageUrl: null,
          order: 12,
        ),
      ];

  // Executive Members (कार्यकारणी सदस्य)
  static List<CommitteeModel> get executiveMembers => [
        // वाघोडिया रोड / आजवा रोड (Waghodia Road / Ajwa Road)
        CommitteeModel(
          id: 'exec_1',
          name: 'अमराराम',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'मुलारामजी सोलंकी',
          location: 'चौकड़ीया',
          area: 'वाघोडिया रोड / आजवा रोड',
          gotra: 'सोलंकी',
          phone: '',
          email: null,
          imageUrl: null,
          imageStoragePath: 'committee_members/amraram_13.png',
          order: 13,
        ),

        CommitteeModel(
          id: 'exec_2',
          name: 'पेमाराम',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'भैरारामजी चोयल',
          location: 'धनला',
          area: 'वाघोडिया रोड / आजवा रोड',
          gotra: 'चोयल',
          phone: '',
          email: null,
          imageUrl: null,
          order: 14,
        ),

        CommitteeModel(
          id: 'exec_3',
          name: 'कानाराम',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'पुकारामजी सैणचा',
          location: 'हिमलीयावास',
          area: 'वाघोडिया रोड / आजवा रोड',
          gotra: 'सैणचा',
          phone: '',
          email: null,
          imageUrl: null,
          order: 15,
        ),

        CommitteeModel(
          id: 'exec_4',
          name: 'बाबुलाल',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'ढगलारामजी गेहलोत',
          location: 'राणावास',
          area: 'वाघोडिया रोड / आजवा रोड',
          gotra: 'गेहलोत',
          phone: '',
          email: null,
          imageUrl: null,
          order: 16,
        ),

        // तरसाली / मकरपुरा (Tarsali / Makarpura)
        CommitteeModel(
          id: 'exec_5',
          name: 'जगदीश',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'लुंबारामजी पंवार',
          location: 'आकणवास',
          area: 'तरसाली / मकरपुरा',
          gotra: 'पंवार',
          phone: '',
          email: null,
          imageUrl: null,
          order: 17,
        ),

        CommitteeModel(
          id: 'exec_6',
          name: 'रूपाराम',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'आदारामजी पंवार',
          location: 'मलसा बावडी',
          area: 'तरसाली / मकरपुरा',
          gotra: 'पंवार',
          phone: '',
          email: null,
          imageUrl: null,
          order: 18,
        ),

        CommitteeModel(
          id: 'exec_7',
          name: 'खीमाराम',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'लालारामजी देवड़ा',
          location: 'भगवानपुरा',
          area: 'तरसाली / मकरपुरा',
          gotra: 'देवड़ा',
          phone: '',
          email: null,
          imageUrl: null,
          order: 19,
        ),

        // मंजुसर/छाणी/बाजवा (Manjusar/Chhani/Bajwa)
        CommitteeModel(
          id: 'exec_8',
          name: 'सोहनलाल',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'हिरालालजी चोयल',
          location: 'गुडा ठाकुरजी',
          area: 'मंजुसर/छाणी/बाजवा',
          gotra: 'चोयल',
          phone: '',
          email: null,
          imageUrl: null,
          order: 20,
        ),

        CommitteeModel(
          id: 'exec_9',
          name: 'सोहनलाल',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'पेमारामजी राठोड',
          location: 'गुडा केशरसिंह',
          area: 'मंजुसर/छाणी/बाजवा',
          gotra: 'राठोड',
          phone: '',
          email: null,
          imageUrl: null,
          order: 21,
        ),

        CommitteeModel(
          id: 'exec_10',
          name: 'दिनेश',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'डुगारामजी परिहारिया',
          location: 'पडासला खुर्ड',
          area: 'मंजुसर/छाणी/बाजवा',
          gotra: 'परिहारिया',
          phone: '',
          email: null,
          imageUrl: null,
          order: 22,
        ),

        // भायली, वासणा, कलाली, सेवासी, गौत्री (Bhayli, Vasna, Kalali, Sevasi, Gotri)
        CommitteeModel(
          id: 'exec_11',
          name: 'चौथाराम',
          position: 'कार्यकारणी सदस्य',
          positionEn: 'Executive Member',
          fatherName: 'वेनारामजी भायल',
          location: 'गुडा सुरसिंह',
          area: 'भायली, वासणा, कलाली, सेवासी, गौत्री',
          gotra: 'भायल',
          phone: '',
          email: null,
          imageUrl: null,
          order: 23,
        ),
      ];

  // All Committee Members
  static List<CommitteeModel> get allMembers => [
        ...executiveCommittee,
        ...executiveMembers,
      ];
}
