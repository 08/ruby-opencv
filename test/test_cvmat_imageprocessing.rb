#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8-unix -*-
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/helper'

include OpenCV

# Tests for image processing functions of OpenCV::CvMat
class TestCvMat_imageprocessing < OpenCVTestCase
  FILENAME_LENA256x256 = File.expand_path(File.dirname(__FILE__)) + '/samples/lena-256x256.jpg'
  FILENAME_LENA32x32 = File.expand_path(File.dirname(__FILE__)) + '/samples/lena-32x32.jpg'

  def test_sobel
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)

    mat1 = mat0.sobel(1, 0).convert_scale_abs(:scale => 1, :shift => 0)
    mat2 = mat0.sobel(0, 1).convert_scale_abs(:scale => 1, :shift => 0)
    mat3 = mat0.sobel(1, 1).convert_scale_abs(:scale => 1, :shift => 0)
    mat4 = mat0.sobel(1, 1, 3).convert_scale_abs(:scale => 1, :shift => 0)
    mat5 = mat0.sobel(1, 1, 5).convert_scale_abs(:scale => 1, :shift => 0)

    assert_equal('30a26b7287fac75bb697bc7eef6bb53a', hash_img(mat1))
    assert_equal('b740afb13b556d55280fa785190ac902', hash_img(mat2))
    assert_equal('36c29ca64a599e0f5633f4f3948ed858', hash_img(mat3))
    assert_equal('36c29ca64a599e0f5633f4f3948ed858', hash_img(mat4))
    assert_equal('30b9e8fd64e7f86c50fb67d8703628e3', hash_img(mat5))

    assert_equal(:cv16s, CvMat.new(16, 16, :cv8u, 1).sobel(1, 1).depth)
    assert_equal(:cv32f, CvMat.new(16, 16, :cv32f, 1).sobel(1, 1).depth)

    (DEPTH.keys - [:cv8u, :cv32f]).each { |depth|
      assert_raise(RuntimeError) {
        CvMat.new(3, 3, depth).sobel(1, 1)
      }
    }

    # Uncomment the following lines to view the images
    # snap(['original', mat0], ['sobel(1,0)', mat1], ['sobel(0,1)', mat2],
    #      ['sobel(1,1)', mat3], ['sobel(1,1,3)', mat4], ['sobel(1,1,5)', mat5])
  end

  def test_laplace
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)

    mat1 = mat0.laplace.convert_scale_abs(:scale => 1, :shift => 0)
    mat2 = mat0.laplace(3).convert_scale_abs(:scale => 1, :shift => 0)
    mat3 = mat0.laplace(5).convert_scale_abs(:scale => 1, :shift => 0)

    assert_equal('824f8de75bfead5d83c4226f3948ce69', hash_img(mat1))
    assert_equal('824f8de75bfead5d83c4226f3948ce69', hash_img(mat2))
    assert_equal('23850bb8cfe9fd1b82cd73b7b4659369', hash_img(mat3))

    assert_equal(:cv16s, CvMat.new(16, 16, :cv8u, 1).laplace.depth)
    assert_equal(:cv32f, CvMat.new(16, 16, :cv32f, 1).laplace.depth)

    (DEPTH.keys - [:cv8u, :cv32f]).each { |depth|
      assert_raise(RuntimeError) {
        CvMat.new(3, 3, depth).laplace
      }
    }

    # Uncomment the following line to view the images
    # snap(['original', mat0], ['laplace', mat1], ['laplace(3)', mat2], ['laplace(5)', mat3])
  end

  def test_canny
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)
    mat1 = mat0.canny(50, 200)
    mat2 = mat0.canny(50, 200, 3)
    mat3 = mat0.canny(50, 200, 5)

    assert_equal('ec3e88035bb98b5c5f1a08c8e07ab0a8', hash_img(mat1))
    assert_equal('ec3e88035bb98b5c5f1a08c8e07ab0a8', hash_img(mat2))
    assert_equal('1983a6d325d11eea3261462103b0dae1', hash_img(mat3))

    # Uncomment the following line to view the images
    # snap(['canny(50,200)', mat1], ['canny(50,200,3)', mat2], ['canny(50,200,5)', mat3])
  end

  def test_pre_corner_detect
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)
    mat1 = mat0.pre_corner_detect
    mat2 = mat0.pre_corner_detect(3)
    mat3 = mat0.pre_corner_detect(5)

    assert_equal('fe7c8a1d07a3dd0fb6a02d6a6de0fe9f', hash_img(mat1))
    assert_equal('fe7c8a1d07a3dd0fb6a02d6a6de0fe9f', hash_img(mat2))
    assert_equal('42e7443ffd389d15343d3c6bdc42f553', hash_img(mat3))

    # Uncomment the following lines to show the images
    # snap(['original', mat0], ['pre_coner_detect', mat1],
    #      ['pre_coner_detect(3)', mat2], ['pre_coner_detect(5)', mat3])
  end

  def test_corner_eigenvv
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)
    mat1 = mat0.corner_eigenvv(3)
    mat2 = mat0.corner_eigenvv(3, 3)

    flunk('FIXME: CvMat#corner_eigenvv is not tested yet.')
  end

  def test_corner_min_eigen_val
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)
    mat1 = mat0.corner_min_eigen_val(3)
    mat2 = mat0.corner_min_eigen_val(3, 3)

    flunk('FIXME: CvMat#corner_min_eigen_val is not tested yet.')
  end

  def test_corner_harris
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)
    mat1 = mat0.corner_harris(3)
    mat2 = mat0.corner_harris(3, 3)
    mat3 = mat0.corner_harris(3, 3, 0.04)
    mat4 = mat0.corner_harris(3, 7, 0.01)

    assert_equal('6ceb54b54cc98a72de7cb75649fb0a12', hash_img(mat1))
    assert_equal('6ceb54b54cc98a72de7cb75649fb0a12', hash_img(mat2))
    assert_equal('6ceb54b54cc98a72de7cb75649fb0a12', hash_img(mat3))
    assert_equal('4e703deb9a418bbf37e3283f4a7d4d32', hash_img(mat4))

    # Uncomment the following lines to show the images
    # snap(['original', mat0], ['corner_harris(3)', mat1], ['corner_harris(3,3)', mat2],
    #      ['corner_harris(3,3,0.04)', mat3], ['corner_harris(3,7,0.01)', mat4])
  end

  def test_find_corner_sub_pix
    flunk('FIXME: CvMat#find_corner_sub_pix is not implemented yet.')
  end

  def test_good_features_to_track
    mat0 = CvMat.load(FILENAME_LENA32x32, CV_LOAD_IMAGE_GRAYSCALE)
    mask = create_cvmat(mat0.rows, mat0.cols, :cv8u, 1) { |j, i, c|
      if (i > 8 and i < 18) and (j > 8 and j < 18)
        CvScalar.new(1)
      else
        CvScalar.new(0)
      end
    }

    corners1 = mat0.good_features_to_track(0.2, 5)
    corners2 = mat0.good_features_to_track(0.2, 5, :mask => mask)
    corners3 = mat0.good_features_to_track(0.2, 5, :block_size => 7)
    corners4 = mat0.good_features_to_track(0.2, 5, :use_harris => true)
    corners5 = mat0.good_features_to_track(0.2, 5, :k => 0.01)
    corners6 = mat0.good_features_to_track(0.2, 5, :max => 1)

    expected1 = [[24, 7], [20, 23], [17, 11], [26, 29], [30, 24],
                 [19, 16], [28, 2], [13, 18], [14, 4]]
    assert_equal(expected1.size, corners1.size)
    expected1.each_with_index { |e, i|
      assert_equal(e[0], corners1[i].x.to_i)
      assert_equal(e[1], corners1[i].y.to_i)
    }
    expected2 = [[17, 11], [17, 16]]
    assert_equal(expected2.size, corners2.size)
    expected2.each_with_index { |e, i|
      assert_equal(e[0], corners2[i].x.to_i)
      assert_equal(e[1], corners2[i].y.to_i)
    }

    expected3 = [[21, 7], [22, 23], [18, 12], [28, 4], [28, 26],
                 [17, 27], [13, 20], [10, 11], [14, 5]]
    assert_equal(expected3.size, corners3.size)
    expected3.each_with_index { |e, i|
      assert_equal(e[0], corners3[i].x.to_i)
      assert_equal(e[1], corners3[i].y.to_i)
    }

    expected4 = [[24, 8], [20, 23], [16, 11],
                 [20, 16],[27, 28], [28, 2]]
    assert_equal(expected4.size, corners4.size)
    expected4.each_with_index { |e, i|
      assert_equal(e[0], corners4[i].x.to_i)
      assert_equal(e[1], corners4[i].y.to_i)
    }

    expected5 = [[24, 7], [20, 23], [17, 11], [26, 29], [30, 24],
                 [19, 16], [28, 2], [13, 18], [14, 4]]
    assert_equal(expected5.size, corners5.size)
    expected5.each_with_index { |e, i|
      assert_equal(e[0], corners5[i].x.to_i)
      assert_equal(e[1], corners5[i].y.to_i)
    }

    assert_equal(1, corners6.size)
    assert_equal(24, corners6[0].x.to_i)
    assert_equal(7, corners6[0].y.to_i)

    assert_raise(ArgumentError) {
      mat0.good_features_to_track(0.2, 5, :max => 0)
    }
  end

  def test_sample_line
    flunk('FIXME: CvMat#sample_line is not implemented yet.')
  end

  def test_rect_sub_pix
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    center = CvPoint2D32f.new(mat0.width / 2, mat0.height / 2)
    mat1 = mat0.rect_sub_pix(center)
    mat2 = mat0.rect_sub_pix(center, mat0.size)
    mat3 = mat0.rect_sub_pix(center, CvSize.new(512, 512))

    assert_equal('b3dc0e31260dd42b5341471e23e825d3', hash_img(mat1))
    assert_equal('b3dc0e31260dd42b5341471e23e825d3', hash_img(mat2))
    assert_equal('cc27ce8f4068efedcd31c4c782c3825c', hash_img(mat3))
  end

  def test_quadrangle_sub_pix
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    angle = 60 * Math::PI / 180
    map_matrix = CvMat.new(2, 3, :cv32f, 1)
    map_matrix[0] = CvScalar.new(Math.cos(angle))
    map_matrix[1] = CvScalar.new(-Math.sin(angle))
    map_matrix[2] = CvScalar.new(mat0.width * 0.5)
    map_matrix[3] = CvScalar.new(-map_matrix[1][0])
    map_matrix[4] = map_matrix[0]
    map_matrix[5] = CvScalar.new(mat0.height * 0.5)

    mat1 = mat0.quadrangle_sub_pix(map_matrix)
    mat2 = mat0.quadrangle_sub_pix(map_matrix, mat0.size)
    mat3 = mat0.quadrangle_sub_pix(map_matrix, CvSize.new(512, 512))

    assert_equal('f170c05fa50c3ac2a762d7b3f5c4ae2f', hash_img(mat1))
    assert_equal('f170c05fa50c3ac2a762d7b3f5c4ae2f', hash_img(mat2))
    assert_equal('4d949d5083405381ad9ea09dcd95e5a2', hash_img(mat3))
  end

  def test_resize
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    mat1 = mat0.resize(CvSize.new(512, 512))
    mat2 = mat0.resize(CvSize.new(512, 512), :linear)
    mat3 = mat0.resize(CvSize.new(512, 512), :nn)
    mat4 = mat0.resize(CvSize.new(128, 128), :area)
    mat5 = mat0.resize(CvSize.new(128, 128), :cubic)

    assert_equal('b2203ccca2c17b042a90b79704c0f535', hash_img(mat1))
    assert_equal('b2203ccca2c17b042a90b79704c0f535', hash_img(mat2))
    assert_equal('ba8f2dee2329aaa6309de4770fc8fa55', hash_img(mat3))
    assert_equal('8a28a2748b0cfc87205d65c625187867', hash_img(mat4))
    assert_equal('de5c30fcd9e817aa282ab05388de995b', hash_img(mat5))
  end

  def test_warp_affine
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    map_matrix = CvMat.new(2, 3, :cv32f, 1)
    # center: (128, 128), angle: 25 deg., scale: 1.0
    map_matrix[0] = CvScalar.new(0.90631)
    map_matrix[1] = CvScalar.new(0.42262)
    map_matrix[2] = CvScalar.new(-42.10254)
    map_matrix[3] = CvScalar.new(-0.42262)
    map_matrix[4] = CvScalar.new(0.90631)
    map_matrix[5] = CvScalar.new(66.08774)

    mat1 = mat0.warp_affine(map_matrix)
    mat2 = mat0.warp_affine(map_matrix, :nn)
    mat3 = mat0.warp_affine(map_matrix, :linear, :fill_outliers, CvColor::Yellow)
    mat4 = mat0.warp_affine(map_matrix, :linear, :inverse_map)

    assert_equal('da3d7cdefabbaf84c4080ecd40d00897', hash_img(mat1))
    assert_equal('b4abcd12c4e1103c3de87bf9ad854936', hash_img(mat2))
    assert_equal('26f6b10e955125c91fd7e63a63cc06a3', hash_img(mat3))
    assert_equal('cc4eb5d8eb7cb2c0b76941bc38fb91b1', hash_img(mat4))

    assert_raise(TypeError) {
      mat0.warp_affine("foobar")
    }
  end

  def test_rotation_matrix2D
    mat1 = CvMat.rotation_matrix2D(CvPoint2D32f.new(10, 20), 60, 2.0)
    expected = [1.0, 1.73205, -34.64102,
                -1.73205, 1.0, 17.32051]
    assert_equal(2, mat1.rows)
    assert_equal(3, mat1.cols)
    assert_equal(:cv32f, mat1.depth)
    assert_equal(1, mat1.channel)
    expected.each_with_index { |x, i|
      assert_in_delta(x, mat1[i][0], 0.001)
    }
  end

  def test_warp_perspective
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    # Homography
    #   <src>     =>    <dst>
    # (0, 0)      =>  (50, 0)
    # (255, 0)    =>  (205, 0)
    # (255, 255)  =>  (255, 220)
    # (0, 255)    =>  (0, 275)
    map_matrix = CvMat.new(3, 3, :cv32f, 1)
    map_matrix[0] = CvScalar.new(0.72430)
    map_matrix[1] = CvScalar.new(-0.19608) 
    map_matrix[2] = CvScalar.new(50.00000) 
    map_matrix[3] = CvScalar.new(0.0) 
    map_matrix[4] = CvScalar.new(0.62489)
    map_matrix[5] = CvScalar.new(0.0)
    map_matrix[6] = CvScalar.new(0.00057)
    map_matrix[7] = CvScalar.new(-0.00165)
    map_matrix[8] = CvScalar.new(1.00000)
    
    mat1 = mat0.warp_perspective(map_matrix)
    mat2 = mat0.warp_perspective(map_matrix, :nn)
    mat3 = mat0.warp_perspective(map_matrix, :linear, :inverse_map)
    mat4 = mat0.warp_perspective(map_matrix, :linear, :fill_outliers, CvColor::Yellow)

    assert_equal('bba3a5395f9dd9a400a0083ae74d8986', hash_img(mat1))
    assert_equal('a0cc4f329f459410293b75b417fc4f25', hash_img(mat2))
    assert_equal('3e34e6ed2404056bb72e86edf02610cb', hash_img(mat3))
    assert_equal('71bd12857d2e4ac0c919652c2963b4e1', hash_img(mat4))

    assert_raise(TypeError) {
      mat0.warp_perspective("foobar")
    }
  end

  def test_remap
    mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    matx = CvMat.new(mat0.height, mat0.width, :cv32f, 1).clear
    maty = CvMat.new(mat0.height, mat0.width, :cv32f, 1).clear

    cos30, sin30 = Math.cos(30 * Math::PI / 180), Math.sin(30 * Math::PI / 180)
    half_width, half_height = mat0.width / 2, mat0.height / 2
    mat0.height.times { |j|
      mat0.width.times { |i|
        x0 = i - half_width
        y0 = j - half_height
        x = x0 * cos30 - y0 * sin30 + half_width
        y = x0 * sin30 + y0 * cos30 + half_height
        matx[j, i] = CvScalar.new(x)
        maty[j, i] = CvScalar.new(y)
      }
    }

    mat1 = mat0.remap(matx, maty)
    mat2 = mat0.remap(matx, maty, :nn)
    mat3 = mat0.remap(matx, maty, :linear, :fill_outliers, CvColor::Yellow)

    assert_equal('586716c0262a3e03a54b9fc6e671e5f7', hash_img(mat1))
    assert_equal('5461ecdee23d5e8a9099500d631c9f0f', hash_img(mat2))
    assert_equal('1f6b73925056298c566e8e727627d929', hash_img(mat3))

    assert_raise(TypeError) {
      mat0.remap('foo', maty)
    }
    assert_raise(TypeError) {
      mat0.remap(matx, 'bar')
    }
  end

  def test_log_polar
    flunk('FIXME: CvMat#log_polar is not implemented yet.')
  end
end

